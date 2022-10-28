class Receiver
{
    poNumber := ""
    partNumber := ""
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