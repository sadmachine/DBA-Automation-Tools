; === Script Information =======================================================
; Name .........: Receiving Controller
; Description ..: The puppet master of the receiving process
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Receiving.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; Revision 2 (03/24/2023)
; * Update how actions are created, use Queue instead of running immediately
;
; Revision 3 (03/31/2023)
; * Update to properly call queue methods
;
; Revision 4 (04/06/2023)
; * Run receiving log and inspection reports as queue jobs
;
; Revision 5 (04/30/2023)
; * Add additional logging
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Controllers.Receiving
class Receiving extends Controllers.Base
{
    receiver := ""

    __New()
    {
        this._bootstrap()
    }

    _bootstrap()
    {
        UI.Base.defaultFont := {options: "s12", fontName: ""}
        UI.Base.defaultMargin := 5
        UI.MsgBoxObj.defaultWidth := 320
        #.log("app").info(A_ThisFunc, "Complete")
    }

    bootstrapReceiver(receiver)
    {
        this.receiver := receiver
        this.receiver.identification := UI.Required.InputBox("Enter Employee ID #")
        #.log("app").info(A_ThisFunc, "Identification: " this.receiver.identification)
        this.receiver.poNumber := UI.Required.InputBox("Enter PO #")
        #.log("app").info(A_ThisFunc, "PO #: " this.receiver.poNumber)
        this.receiver.partNumber := UI.Required.InputBox("Enter Part #")
        #.log("app").info(A_ThisFunc, "Part #: " this.receiver.partNumber)
        this.receiver.lots.push(new Models.LotInfo())
        this.receiver.lots["current"].lotNumber := UI.Required.InputBox("Enter Lot #")
        #.log("app").info(A_ThisFunc, "Lot #: " this.receiver.lots["current"].lotNumber)
        this.receiver.lots["current"].quantity := UI.Required.InputBox("Enter Quantity")
        #.log("app").info(A_ThisFunc, "Quantity: " this.receiver.lots["current"].quantity)

        this.receiver.buildRelated()

        try {
            this.receiver.assertPoExists()
            this.receiver.assertPoIsUnique()
            this.receiver.assertPoHasCorrectStatus()
            this.receiver.assertPoHasPartNumber()
            this.receiver.assertPoHasCorrectQty()
        } catch e {
            if (e.what != "ValidationException") {
                throw e
            }
            @.friendlyException(e, "PO Criteria is Invalid")
            ExitApp
        }

        #.log("app").info(A_ThisFunc, "Complete")
    }

    displayReceivingResults()
    {
        this.receivingResults := new Views.PoLookupResults(this)
        this.receivingResults.display(this.receiver)
    }

    newReceivingTransaction()
    {
        try {

            this.receiver.lineReceived := this.receivingResults.getSelectedLine()
            #.log("app").info(A_ThisFunc, "Line Received: " this.receiver.lineReceived)
            receiver := this.receiver

            this.cleanup()

            new Actions.ReceivingTransaction(receiver)
            receiver.acquireInspectionNumbers()
            new Actions.PrintLabels(receiver)
            for n, lot in receiver.lots {
                ; Queue.createJob(new Actions.PrintLabels(receiver, n))
                #.Queue.createJob(new Actions.ReceivingLog(receiver, n))
                #.Queue.createJob(new Actions.InspectionReport(receiver, n))
            }
            this.receiver := receiver
        } catch e {
            if (@.subclassOf(e, "@")) {
                @.friendlyException(e)
                this.cleanup(true)
                ExitApp
            }

            this.cleanup(true)
            throw e
        }
    }

    cleanup(force := false)
    {
        if (WinExist(DBA.Windows.POReceipts)) {
            WinActivate, % DBA.Windows.POReceipts
            WinClose, % DBA.Windows.POReceipts
            if (force) {
                WinWaitActive, % "Warning", % "&Lose Changes", 1
                if (!ErrorLevel) {
                    Send % "!L"
                    WinWaitClose, % "Warning",,1
                    if (ErrorLevel) {
                        WinKill, % "Warning"
                        WinKill, % DBA.Windows.POReceipts
                    }
                }
            } else {
                WinWaitActive, % "Warning", % "&Lose Changes", 1
                if (!ErrorLevel) {
                    WinActivate, % "Warning"
                    WinWaitClose, % "Warning"
                }
            }
            WinWaitClose, % DBA.Windows.POReceipts
        }
    }
}
