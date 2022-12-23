; DBA.DbConnection
class DbConnection extends OdbcConnection
{
    DSN := "DBA NG"
    UID := "SYSDBA"
    PWD := "masterkey"
    RO := true
    colDelim := "||"
    connectionStr := ""
    __New(DSN := "DBA NG", UID := "SYSDBA", PWD := "masterkey", colDelim := "")
    {
        this.DSN := DSN
        this.UID := UID
        this.PWD := PWD

        if (colDelim != "") {
            this.colDelim := colDelim
        }
        this._buildConnectionStr()

        base.__New(this.connectionStr)
    }

    ReadOnly(is_ro)
    {
        this.RO := is_ro
    }

    _buildConnectionStr()
    {
        ro_str := (this.RO ? "READONLY=YES" : "")
        colDelim := this.colDelim
        this.connectionStr := "DSN=" this.DSN ";UID=" this.UID ";PWD=" this.PWD ";" ro_str ";coldelim=" colDelim
    }

    query(qStr)
    {
        this._buildConnectionStr()
        thisResult := new DBA.DbResults(base.query(qStr), this.colDelim)
        return thisResult
    }
}