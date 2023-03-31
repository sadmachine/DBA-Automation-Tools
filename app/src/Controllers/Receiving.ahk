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
        this.receiver.poNumber := UI.Required.InputBox("Enter PO #")
        this.receiver.partNumber := UI.Required.InputBox("Enter Part #")
        this.receiver.lots.push(new Models.LotInfo())
        this.receiver.lots["current"].lotNumber := UI.Required.InputBox("Enter Lot #")
        this.receiver.lots["current"].quantity := UI.Required.InputBox("Enter Quantity")

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
            receiver := this.receiver

            new Actions.ReceivingTransaction(receiver)
            receiver.acquireInspectionNumbers()
            new Actions.PrintLabels(receiver)
            new Actions.ReceivingLog(receiver)
            for n, lot in receiver.lots {
                ; Queue.createJob(new Actions.PrintLabels(receiver, n))
                ; Queue.createJob(new Actions.ReceivingLog(receiver, n))
                #.Queue.createJob(new Actions.InspectionReport(receiver, n))
            }
            this.receiver := receiver
        } catch e {
            @.friendlyException(e)
            this.cleanup()
            ExitApp
        }
    }

    cleanup()
    {
        if (WinExist(DBA.Windows.POReceipts)) {
            WinClose, % DBA.Windows.POReceipts
            WinWaitActive, % "Warning", % "&Lose Changes", 1
            if (!ErrorLevel) {
                Send % "!L"
                WinWaitClose, % "Warning",,1
                if (ErrorLevel) {
                    WinKill, % "Warning"
                    WinKill, % DBA.Windows.POReceipts
                }
            }
        }
    }
}
