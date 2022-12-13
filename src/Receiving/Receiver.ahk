class Receiver
{
    poNumber := ""
    partNumber := ""
    lineReceived := ""
    partDescription := ""
    lineQuantity := ""
    supplier := ""
    lotNumbers := []
    quantities := []
    locations := []
    hasCert := []

    __New()
    {
    }

    RequestPONumber()
    {
        result := this._Request("PO #")
        this.poNumber := result.value
    }

    RequestPartNumber()
    {
        result := this._Request("Part #")
        this.partNumber := result.value
    }

    RequestLotNumber()
    {
        result := this._Request("Lot #")
        this.lotNumbers.push(result.value)
    }

    RequestQuantity()
    {
        result := this._Request("Quantity")
        this.quantities.Push(result.value)
    }

    RequestLocation()
    {
        result := this._Request("Location")
        this.locations.Push(result.value)
    }

    RequestCertInfo()
    {
        result := UI.YesNoBox("Does lot # " this.GetCurrentLotInfo("number") " have certification?")
        this.hasCert.push(result.value)
    }

    GetCurrentLotInfo(key := "")
    {
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

    PullAdditionalInfo()
    {
        generalConfig := new IniConfig("database")
        DB := new DBConnection(generalConfig.get("main.dsn"))
        query := "SELECT p.qty, i.supplier, i.descript FROM podetl p LEFT JOIN item i ON p.reference = i.itemcode WHERE p.line='" this.lineReceived "' AND p.ponum='" this.poNumber "' AND p.reference='" this.partNumber "';"
        res := DB.query(query)
        if (res.empty()) {
            throw Exception("Could not pull in additional receiving details from PO")
        }
        this.supplier := res.row(1)["supplier"]
        this.lineQuantity := res.row(1)["qty"]
        this.partDescription := res.row(1)["descript"]
    }

    _Request(field_name)
    {
        result := UI.InputBox("Enter " field_name)
        if (result.canceled)
        {
            MsgBox % "You must supply a " field_name " to continue. Exiting..."
            ExitApp
        }
        return result
    }
}