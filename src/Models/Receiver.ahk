; Models.Receiver
class Receiver
{
    _poNumber := ""
    partNumber := ""
    _lineReceived := ""
    partDescription := ""
    lineQuantity := ""
    supplier := ""
    lotNumbers := []
    quantities := []
    locations := []
    hasCert := []
    related := {}

    poNumber[]
    {
        get
        {
            return this._poNumber
        }
        set
        {
            this._poNumber := String.toUpper(value)
            return this._poNumber
        }
    }

    lineReceived[]
    {
        get
        {
            return this._lineReceived
        }
        set
        {
            this._lineReceived := value
            this._buildLineInfo()
            return this._lineReceived
        }
    }

    currentLotInfo[key := ""]
    {
        get {
            lotInfo := {}
            index := this.lotNumbers.MaxIndex()
            lotInfo["number"] := this.lotNumbers[index]
            lotInfo["quantity"] := this.quantities[index]
            lotInfo["location"] := this.locations[index]
            lotInfo["hasCert"] := this.hasCert[index]
            if (key == "" || !lotInfo.HasKey(key))
                return lotInfo
            return lotInfo[key]
        }
    }

    buildRelated()
    {
        this.related["porder"] := Models.DBA.porder.build("ponum='" this.poNumber "'")
        this.related["podetl"] := Models.DBA.podetl.build("ponum='" this.poNumber "' AND reference='" this.partNumber "' AND (qty*1.1)-qtyr>='" this.quantities[1] "'", "line ASC")
    }

    assertPoExists()
    {
        if (this.related["porder"].Count() == 0) {
            throw Exception("AssertionException", "Models.Receiver.assertPoExists()", "No POs matched the PO # entered ('" this.poNumber "').")
        }
    }

    assertPoIsUnique()
    {
        if (this.related["porder"].Count() > 1) {
            throw Exception("AssertionException", "Models.Receiver.assertPoIsUnique()", "More than 1 PO matches the PO # number entered (' " this.poNumber " '), this must be an error.")
        }
    }

    assertPoHasCorrectStatus()
    {
        if (!InStr("Open,Printed", this.related["porder"][1].status)) {
            throw Exception("AssertionException", "Models.Receiver.assertPoHasCorrectStatus()", "The PO '" this.poNumber "' has status '" this.related["porder"][1].status "'. Status should be either 'Open' or 'Printed'")
        }
    }

    assertPoHasPartNumber()
    {
        if (this.related["podetl"].Count() == 0) {
            throw Exception("AssertionException", "Models.Receiver.assertPoHasPartNumber()", "The PO '" this.poNumber "' did not contain a line with the specified part number '" this.partNumber "'.")
        }
    }

    _buildLineInfo()
    {
        this.receivedLine := Models.DBA.podetl.build("p.line='" this.lineReceived "' AND p.ponum='" this.poNumber "' AND p.reference='" this.partNumber "'")[1]
        this.receivedItem := new Models.DBA.item(this.receivedLine.reference)
        query := "SELECT p.qty, i.supplier, i.descript FROM podetl p LEFT JOIN item i ON p.reference = i.itemcode WHERE p.line='" this.lineReceived "' AND p.ponum='" this.poNumber "' AND p.reference='" this.partNumber "';"
        res := DB.query(query)
        if (!this.receivedLine.exists || !this.receivedItem.exists) {
            throw Exception("DatabaseException", "Models.Receiver._buildLineInfo()", "Could not pull in additional receiving details from PO")
        }
        this.supplier := this.receivedItem.supplier
        this.partDescription := this.receivedItem.descript
        this.lineQuantity := this.receivedLine.qty
    }

}