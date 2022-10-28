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
        results := this.DB.query("SELECT status FROM porder WHERE ponum='" String.toUpper(this.receiver.poNumber) "';")

        if (results.count() > 1)
        {
            MsgBox % "More than 1 PO matches the PO # number entered, this must be an error."
            ExitApp
        }

        if (!InStr("Open,Printed", results.row(1)["status"]))
        {
            MsgBox % "The PO '" this.receiver.poNumber "' has status '" results.row(1)["status"] "'. Status should be either 'Open' or 'Printed'"
            ExitApp
        }
    }

    FindMatchingLines()
    {
        results := this.DB.query("SELECT line, reference AS part_number, qty, qtyr AS qty_received FROM podetl WHERE ponum='" this.receiver.poNumber "' AND reference='" this.receiver.partNumber "' AND qty-qtyr>='" this.receiver.quantities[1] "';")

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