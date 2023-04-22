; === Script Information =======================================================
; Name .........: DBA.DbConnection
; Description ..: Handles the database connection to DBA
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/19/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: DbConnection.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/19/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; DBA.DbConnection
class DbConnection extends OdbcConnection
{
    static DSN := "DBA NG"
    static UID := "SYSDBA"
    static PWD := "masterkey"
    static RO := true
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

        super.__New(this.connectionStr)
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
        thisResult := DBA.DbResults(super.query(qStr), this.colDelim)
        return thisResult
    }
}