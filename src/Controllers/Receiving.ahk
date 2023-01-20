; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
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
        UI.MsgBoxObj.defaultWidth := 300
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

        this.receiver.assertPoExists()
        this.receiver.assertPoIsUnique()
        this.receiver.assertPoHasCorrectStatus()
        this.receiver.assertPoHasPartNumber()
    }

    displayReceivingResults()
    {
        this.receivingResults := new Views.PoLookupResults(this)
        this.receivingResults.display(this.receiver)
    }

    newReceivingTransaction()
    {
        this.receiver.lineReceived := this.receivingResults.getSelectedLine()
        receiver := this.receiver

        new Actions.ReceivingTransaction(receiver)
        receiver.acquireInspectionNumbers()
        new Actions.ReceivingLog(receiver)
        new Actions.InspectionReport(receiver)
        this.receiver := receiver
    }
}
