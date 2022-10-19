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
        this.FindMatchingLines()
    }

    FindMatchingPO()
    {
        results := this.DB.query("SELECT status FROM porder WHERE ponum='" String.toUpper(this.receiver["po_number"]) "';")

        if (results.count() > 1)
        {
            MsgBox % "More than 1 PO matches the PO # number entered, this must be an error."
            ExitApp
        }

        if (!InStr("Open,Printed", results.row(0)["status"]))
        {
            MsgBox % "The PO '" this.receiver["po_number"] "' has status '" results.row(0)["status"] "'. Status should be either 'Open' or 'Printed'"
            ExitApp
        }
    }

    FindMatchingLines()
    {
        results := this.DB.query("SELECT line, reference AS part_number, qty, qtyr AS qty_received FROM podetl WHERE ponum='" this.receiver["po_number"] "' AND reference='" this.receiver["part_number"] "' AND qty-qtyr>='" this.receiver["quantity"] "';")

        if (results.empty())
        {
            MsgBox % "No parts matched the given criteria."
            ExitApp
        }
        this.results := results
    }

    GetResults()
    {
        return this.results
    }
}