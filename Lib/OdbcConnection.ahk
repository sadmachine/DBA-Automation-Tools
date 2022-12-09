#Include <ADOSQL>

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
        if (SubStr(qStr, 0) != ";")
            qStr .= ";"
        return ADOSQL(this.connectionStr, qStr)
    }
}