; DBA.DbResult
class DbResults
{
    answer := ""
    rawAnswer := ""
    delim := "|"

    __New(queryOutput, colDelim := "|")
    {
        local header, index, row
        if (ADOSQL_LastError)
        {
            throw Exception("QueryException", A_ThisFunc, "Query error:`n" ADOSQL_LastError)
        }

        this.delim := colDelim
        this.rawAnswer := queryOutput
        this.answer := StrSplit(this._encodeNewLines(this.rawAnswer), "`n")
        this.lvHeaders := StrReplace(this.answer[1], "_", " ")
        columnHeaders := StrSplit(this.answer[1], this.delim)
        this.columnHeaders := columnHeaders

        ; Keep track of the actual order of each header
        ; so we can put them back in the right order later
        this.headerIndex := {}
        for index,header in columnHeaders
        {
            this.headerIndex[header] := index
        }

        this.colCount := columnheaders.Length()
        this.rows := []
        ; Start at row 2 (skip the headers)
        currentRow := 2

        maxRow := this.answer.Length()
        Loop % maxRow - 1
        {
            this.answer[currentRow] := this._decodeNewLines(this.answer[currentRow])
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

    _encodeNewLines(string)
    {
        return StrReplace(string, "`r`n", "\r\n")
    }

    _decodeNewLines(string)
    {
        return StrReplace(string, "\r\n", "`r`n")
    }

    count()
    {
        return this.rows.length()
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
        Global
        Gui, New, hwndDisplaySQL +AlwaysOnTop,
        Gui, %DisplaySQL%:Add, ListView, x8 y8 w500 r20 +LV0x4000i, % this.lvHeaders
        Gui, %DisplaySQL%:Default

        for index,row in this.rows
        {
            data := []
            for header,record in row
            {
                data[this.headerIndex[header]] := record
            }
            LV_Add("", data*)
        }

        Loop % this.colCount
        {
            LV_ModifyCol(A_Index, "AutoHdr")
        }

        Gui, %DisplaySQL%:Show
        return DisplaySQL
    }
}