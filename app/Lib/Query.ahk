#Include "ADOSQL.ahk"

class DBConnection
{
    DSN := "DBA NG"
    UID := "SYSDBA"
    PWD := "masterkey"
    RO := true
    colDelim := "|"
    connectionStr := ""
    __New(DSN := "DBA NG", UID := "SYSDBA", PWD := "masterkey", colDelim := "")
    {
        this.DSN := DSN
        this.UID := UID
        this.PWD := PWD

        if (colDelim != "") {
            this.colDelim := colDelim
        }

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
        qStr := RTrim(qStr)
        if (SubStr(qStr, -1) != ";")
            qStr .= ";"
        return new Results(ADOSQL(this.connectionStr, qStr), this.colDelim)
    }
}

class Results
{
    answer := ""
    rawAnswer := ""
    delim := "|"
    __New(queryOutput, colDelim := "|")
    {
        if (ADOSQL_LastError)
        {
            throw new Core.SQLException(A_ThisFunc, "Query error:`n" ADOSQL_LastError)
        }
        this.delim := colDelim
        this.rawAnswer := queryOutput
        this.answer := StrSplit(this.rawAnswer, "`n")
        this.lvHeaders := StrReplace(this.answer[1], "_", " ")
        columnHeaders := StrSplit(this.answer[1], this.delim)
        this.columnHeaders := columnHeaders
        this.headerIndex := {}
        for index,header in columnHeaders
        {
            this.headerIndex[header] := index
        }
        this.colCount := columnheaders.Length
        this.rows := []
        currentRow := 2
        maxRow := this.answer.Length
        Loop maxRow - 1
        {
            rowData := StrSplit(this.answer[currentRow], this.delim)
            current := []
            count := 1
            for index,header in columnHeaders
            {
                current[header] := rowData[count]
                count := count + 1
            }
            this.rows.Push(current)
            currentRow++
        }
    }

    count()
    {
        return this.rows.Length
    }

    row(row_num)
    {
        return this.rows[row_num]
    }

    raw()
    {
        return this.rawAnswer
    }

    empty()
    {
        return this.rows.Length == 0
    }

    data()
    {
        return this.rows
    }

    display()
    {
        myGui := Gui()
        myGui.New("hwndDisplaySQL +AlwaysOnTop")
        DisplaySQL := Gui()
        ogcListViewthislvHeaders := DisplaySQL.Add("ListView", "x8 y8 w500 r20 +LV0x4000i", [this.lvHeaders])
        DisplaySQL.Default()

        for index,row in this.rows
        {
            data := []
            for header,record in row
            {
                data[this.headerIndex[header]] := record
            }
            ogcListViewthislvHeaders.Add("", data*)
        }

        Loop this.colCount
        {
            ogcListViewthislvHeaders.ModifyCol(A_Index, "AutoHdr")
        }

        DisplaySQL.Show()
        return DisplaySQL.hwnd
    }
}