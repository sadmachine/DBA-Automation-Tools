#Include <String>
#Include <ADOSQL>
#Include <Query>

class Verify
{
    __New(receiver)
    {
        this.receiver := receiver
        this.DB := new DBConnection()
        this.FindMatchingPO()
        this.FindPartNumberOnPO()
        this.FindMatchingLines()
    }

    FindMatchingPO()
    {
        results := this.DB.query("SELECT status FROM porder WHERE ponum='" String.toUpper(this.receiver.poNumber) "';")

        if (results.count() > 1)
        {
            MsgBox %
            UI.MsgBox("More than 1 PO matches the PO # number entered (' " this.receiver.poNumber " '), this must be an error.")
            ExitApp
        }

        if (results.empty())
        {
            UI.MsgBox("No POs matched the PO # entered ('" this.receiver.poNumber "').")
            ExitApp
        }

        if (!InStr("Open,Printed", results.row(1)["status"]))
        {
            UI.MsgBox("The PO '" this.receiver.poNumber "' has status '" results.row(1)["status"] "'. Status should be either 'Open' or 'Printed'")
            ExitApp
        }
    }

    FindPartNumberOnPO()
    {
        results := this.DB.query("SELECT line, reference AS part_number FROM podetl WHERE ponum='" this.receiver.poNumber "' AND reference='" this.receiver.partNumber "';")

        if (results.empty()) {
            UI.MsgBox("The PO '" this.receiver.poNumber "' did not contain a line with the specified part number '" this.receiver.partNumber "'.")
            ExitApp
        }
    }

    FindMatchingLines()
    {
        results := this.DB.query("SELECT line, reference AS part_number, qty, qtyr AS qty_received FROM podetl WHERE ponum='" this.receiver.poNumber "' AND reference='" this.receiver.partNumber "' AND (qty*1.1)-qtyr>='" this.receiver.quantities[1] "';")

        if (results.empty())
        {
            UI.MsgBox("The quantity entered '" this.receiver.quantities[1] "' is too large to receive against any lines on PO # '" this.receiver.poNumber "' which match part # '" this.receiver.partNumber "'.")
            ExitApp
        }
        this.results := results
    }

    GetResults()
    {
        return this.results
    }
}