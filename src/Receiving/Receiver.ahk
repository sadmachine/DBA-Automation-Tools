class Receiver
{
    po_number := ""
    part_number := ""
    lot_numbers := []
    quantities := []

    input_order := []
    prompts := {}
    readable_fields := {}

    __New()
    {
    }

    RequestPONumber()
    {
        result := this._Request("PO #")
        this.po_number := result.value
    }

    RequestPartNumber()
    {
        result := this._Request("Part #")
        this.part_number := result.value
    }

    RequestLotNumber()
    {
        result := this._Request("Lot #")
        this.lot_number := result.value
    }

    RequestQuantity()
    {
        result := this._Request("Quantity")
        this.quantity := result.value
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