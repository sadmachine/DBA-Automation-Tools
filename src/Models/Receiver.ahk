; Models.Receiver
class Receiver
{
    _poNumber := ""
    partNumber := ""
    _lineReceived := ""
    partDescription := ""
    lineQuantity := ""
    supplier := ""
    _lots := []
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

    lots[index := "", key := ""]
    {
        get {
            if (index == "" && key == "") {
                return this._lots
            }
            lot := ""
            if index is integer
            {
                lot := this._lots[index]
            } else if (index == "current") {
                lot := this._lots[this._lots.MaxIndex()]
            } else {
                throw Exception("InvalidIndexException", "Models.Receiver.lots.get[index:=" index ", key:=" key "]")
            }
            if (key == "" || !lot.HasKey(key))
                return lot
            return lot[key]
        }
    }

    buildRelated()
    {
        this.related["porder"] := Models.DBA.porder.build("ponum='" this.poNumber "'")
        this.related["podetl"] := Models.DBA.podetl.build("ponum='" this.poNumber "' AND reference='" this.partNumber "' AND (qty*1.1)-qtyr>='" this.lots["current"].quantity "'", "line ASC")
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
        GLOBAL DEBUG_MODE
        if (!Models.DBA.podetl.has({"ponum=": this.poNumber, "reference=": this.partNumber})) {
            throw Exception("AssertionException", "Models.Receiver.assertPoHasPartNumber()", "The PO '" this.poNumber "' did not contain a line with the specified part number '" this.partNumber "'.")
        }
    }

    assertPoHasCorrectQty()
    {
        if (!Models.DBA.podetl.has({"ponum=": this.poNumber, "reference=": this.partNumber, "(qty*1.1)-qtyr>=": this.lots["current"].quantity})) {
            throw Exception("AssertionException", "Models.Receiver.assertPoHasPartNumber()", "The qty '" this.lots["current"].quantity "' was more than allowed by any line numbers on PO '" this.poNumber "'.")
        }
    }

    acquireInspectionNumbers()
    {
        Config.lock("receiving.inspectionNumber", Config.Scope.GLOBAL)
        inspectionNumberFile := Config.load("receiving.inspectionNumber")
        for n, lot in this.lots {
            nextInspectionNumber := inspectionNumberfile.get("last.number") + 1
            lot.inspectionNumber := nextInspectionNumber
            inspectionNumberFile.set("last.number", nextInspectionNumber)
        }
        inspectionNumberFile.store()
        Config.unlock("receiving.inspectionNumber", Config.Scope.GLOBAL)
    }

    _buildLineInfo()
    {
        this.receivedLine := Models.DBA.podetl.build("line='" this.lineReceived "' AND ponum='" this.poNumber "' AND reference='" this.partNumber "'")[1]
        this.receivedItem := new Models.DBA.item(this.receivedLine.reference)
        if (!this.receivedLine.exists || !this.receivedItem.exists) {
            throw Exception("DatabaseException", "Models.Receiver._buildLineInfo()", "Could not pull in additional receiving details from PO")
        }
        this.supplier := this.receivedItem.supplier
        this.partDescription := this.receivedItem.descript
        this.lineQuantity := this.receivedLine.qty
    }

}