; DBA.DbConnection
class DbConnection extends OdbcConnection
{
    DSN := "DBA NG"
    UID := "SYSDBA"
    PWD := "masterkey"
    RO := true
    colDelim := "||"
    connectionStr := ""
    __New(DSN := -1, UID := -1, PWD := -1, colDelim := "")
    {
        if (DSN != -1) {
            this.DSN := DSN
        }
        if (UID != -1) {
            this.UID := UID
        }
        if (PWD != -1) {
            this.PWD := PWD
        }

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