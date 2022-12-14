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
        receiver.poNumber := UI.Required.InputBox("Enter PO #")
        receiver.partNumber := UI.Required.InputBox("Enter Part #")
        receiver.lotNumbers.push(UI.Required.InputBox("Enter Lot #"))
        receiver.quantities.push(UI.Required.InputBox("Enter Quantity"))

        receiver.buildRelated()

        receiver.assertPoExists()
        receiver.assertPoIsUnique()
        receiver.assertPoHasCorrectStatus()
        receiver.assertPoHasPartNumber()
    }

    displayReceivingResults()
    {
        this.receivingResults := new Views.PoLookupResults(this)
        this.receivingResults.display(this.receiver)
    }

    newReceivingTransaction()
    {
        this.receiver.lineReceived := this.receivingResults.getSelectedLine()

        Actions.ReceivingTransaction(this.receiver)
        Actions.ReceivingLog(this.receiver)
        Actions.InspectionReport(this.receiver)
    }
}
