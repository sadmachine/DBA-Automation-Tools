#Include "ADOSQL.ahk"

class OdbcConnection
{
    connectionStr := ""
    __New(connectionStr)
    {
        this.connectionStr := connectionStr
    }

    query(qStr)
    {
        qStr := RTrim(qStr)
        if (SubStr(qStr, -1) != ";")
            qStr .= ";"
        return ADOSQL(this.connectionStr, qStr)
    }
}