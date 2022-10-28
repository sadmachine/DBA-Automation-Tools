class Receiver
{
    poNumber := ""
    partNumber := ""
    lotNumbers := []
    quantities := []
    locations := []
    currentIndex := 1

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