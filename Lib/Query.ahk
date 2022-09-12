#include <ADOSQL>

class DBConnection
{
    DSN := "DBA NG"
    UID := "SYSDBA"
    PWD := "masterkey"
    RO := true
    coldelim := "|"
    connectionStr := ""
    __New(DSN := "DBA", UID := "SYSDBA", PWD := "masterkey", coldelim := "")
    {
        this.DSN := DSN
        this.UID := UID
        this.PWD := PWD

        if (coldelim != "") {
            this.coldelim := coldelim
        }

    }

    ReadOnly(is_ro)
    {
        this.RO := is_ro
    }

    _buildConnectionStr()
    {
        ro_str := (this.RO ? "READONLY=YES" : "")
        coldelim := this.coldelim
        this.connectionStr := "DSN=" this.DSN ";UID=" this.UID ";PWD=" this.PWD ";" ro_str ";coldelim=" coldelim
    }

    query(qStr)
    {
        this._buildConnectionStr()
        qStr := RTrim(qStr)
        if (SubStr(qStr, 0) != ";")
            qStr .= ";"
        return new Results(ADOSQL(this.connectionStr, qStr), this.coldelim)
    }
}

class Results
{
    answer := ""
    rawAnswer := ""
    delim := "|"
    __New(queryOutput, coldelim := "|")
    {
        this.delim := coldelim
        this.rawAnswer := queryOutput
        this.answer := StrSplit(this.rawAnswer, "`n")
        this.LV_headers := this.answer[1]
        columnHeaders := StrSplit(this.answer[1], this.delim)
        this.columnHeaders := columnHeaders
        this.colCount := columnheaders.Length()
        this.rows := []
        currentRow := 2
        maxRow := this.answer.Length()
        Loop % maxRow - 1
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
        return this.rows.length() == 0
    }

    data()
    {
        return this.rows
    }

    display()
    {
        Gui, 1:New, +AlwaysOnTop
        Gui, 1:Add, ListView, x8 y8 w500 r20 +LV0x4000i, % this.LV_Headers
        Gui, 1:Default
        
        for index,row in this.rows
        {
            data := []
            for index,record in row
            {
                data.push(record)
            }
            LV_Add("", data*)
        }

        Loop % this.colCount
        {
            LV_ModifyCol(A_Index, "AutoHdr")
        }

        Gui, 1:Show
    }
}