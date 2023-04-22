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
; Revision 5 (04/21/2023)
; * Update for ahk v2
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
        Lib.log("app").info(A_ThisFunc, "Complete")
    }

    bootstrapReceiver(receiver)
    {
        this.receiver := receiver
        this.receiver.identification := UI.Required.InputBox("Enter Employee ID #")
        this.receiver.poNumber := UI.Required.InputBox("Enter PO #")
        this.receiver.partNumber := UI.Required.InputBox("Enter Part #")
        this.receiver.lots.push(Models.LotInfo())
        this.receiver.lots["current"].lotNumber := UI.Required.InputBox("Enter Lot #")
        this.receiver.lots["current"].quantity := UI.Required.InputBox("Enter Quantity")

        this.receiver.buildRelated()

        try {
            this.receiver.assertPoExists()
            this.receiver.assertPoIsUnique()
            this.receiver.assertPoHasCorrectStatus()
            this.receiver.assertPoHasPartNumber()
            this.receiver.assertPoHasCorrectQty()
        } catch Any as e {
            if (e.what != "ValidationException") {
                throw e
            }
            Core.friendlyException(e, "PO Criteria is Invalid")
            ExitApp()
        }
    }

    displayReceivingResults()
    {
        this.receivingResults := Views.PoLookupResults(this)
        this.receivingResults.display(this.receiver)
    }

    newReceivingTransaction()
    {
        try {

            this.receiver.lineReceived := this.receivingResults.getSelectedLine()
            receiver := this.receiver

            Actions.ReceivingTransaction(&receiver)
            receiver.acquireInspectionNumbers()
            Actions.PrintLabels(receiver)
            for n, lot in receiver.lots {
                ; Queue.createJob(Actions.PrintLabels(receiver, n))
                Lib.Queue.createJob(Actions.ReceivingLog(receiver, n))
                Lib.Queue.createJob(Actions.InspectionReport(receiver, n))
            }
            this.receiver := receiver
        } catch Any as e {
            Core.friendlyException(e)
            this.cleanup()
            ExitApp()
        }
    }

    cleanup()
    {
        if (WinExist(DBA.Windows.POReceipts)) {
            WinClose(DBA.Windows.POReceipts)
            ErrorLevel := WinWaitActive("Warning", "&Lose Changes", 1) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
            if (!ErrorLevel) {
                Send("!L")
                ErrorLevel := WinWaitClose("Warning", , 1) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
                if (ErrorLevel) {
                    WinKill("Warning")
                    WinKill(DBA.Windows.POReceipts)
                }
            }
        }
    }
}
