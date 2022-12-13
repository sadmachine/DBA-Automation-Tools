; Models.Receiver
class Receiver
{
    _poNumber := ""
    partNumber := ""
    lineReceived := ""
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
        this.related["porder"] := DBA.RecordSet.build("porder", "ponum='" this.poNumber "'")
        this.related["podetl"] := DBA.RecordSet.buildWith("podetl", "line, reference AS part_number, qty, qtyr AS qty_received", "ponum='" this.poNumber "' AND reference='" this.partNumber "' AND (qty*1.1)-qtyr>='" this.receiver.quantities[1] "'", "line ASC")
    }

    poExists()
    {
        if (this.related["porder"].Count() == 0) {
            UI.MsgBox("No POs matched the PO # entered ('" this.poNumber "').")
            ExitApp
        }
        return true
    }

    poIsUnique()
    {
        if (this.related["porder"].Count() > 1) {
            UI.MsgBox("More than 1 PO matches the PO # number entered (' " this.poNumber " '), this must be an error.")
            ExitApp
        }
        return true
    }

    poHasCorrectStatus()
    {
        if (!InStr("Open,Printed", this.related["porder"][1].status)) {
            UI.MsgBox("The PO '" this.poNumber "' has status '" this.related["porder"][1].status "'. Status should be either 'Open' or 'Printed'")
            ExitApp
        }
        return true
    }

    poHasPartNumber()
    {
        if (this.related["podetl"].Count() == 0)) {
            UI.MsgBox("The PO '" this.poNumber "' did not contain a line with the specified part number '" this.partNumber "'.")
            ExitApp
        }
        return true
    }

    PullAdditionalInfo()
    {
        this.receivedLine := DBA.RecordSet.build("podetl", "p.line='" this.lineReceived "' AND p.ponum='" this.poNumber "' AND p.reference='" this.partNumber "'")[1]
        this.receivedItem := new Models.DBA.item(this.receivedLine.reference)
        query := "SELECT p.qty, i.supplier, i.descript FROM podetl p LEFT JOIN item i ON p.reference = i.itemcode WHERE p.line='" this.lineReceived "' AND p.ponum='" this.poNumber "' AND p.reference='" this.partNumber "';"
        res := DB.query(query)
        if (!this.receivedLine.exists || !this.receivedItem.exists) {
            throw Exception("Could not pull in additional receiving details from PO")
        }
        this.supplier := this.receivedItem.supplier
        this.partDescription := this.receivedItem.descript
        this.lineQuantity := this.receivedLine.qty
    }

}