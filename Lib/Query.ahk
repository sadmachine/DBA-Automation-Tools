Class Query {
  baseConnectStr := "DSN=DBA NG;UID=SYSDBA;PWD=masterkey;ReadOnly=YES;"
  __New(qStr, delim:="|")
  {
    this.delim := delim
    this.connectStr := Query.baseConnectStr "coldelim=" this.delim
    this.qStr := qStr
    this.hasResults := false
    this.rows := Array()
  }

  Run()
  {
    this.rawAnswer := ADOSQL(this.connectStr, this.qStr)
    this.answer := StrSplit(this.rawAnswer, "`n")
    this.LV_headers := this.answer[1]
    columnHeaders := StrSplit(this.answer[1], this.delim)
    this.columnHeaders := columnHeaders
    this.colCount := columnheaders.Count()
    this.rows := Array()
    currentRow := 2
    maxRow := this.answer.MaxIndex()
    Loop % maxRow - 1
    {
      rowData := StrSplit(this.answer[currentRow], this.delim)
      current := {}
      for n, header in this.columnHeaders
      {
        MsgBox % header ": " rowData[n]
        current[header] = rowData[n]
      }
      this.rows.Push(current)
      currentRow++
    }
    this.hasResults := true
    return this.rows
  }

  Raw()
  {
    if (!this.hasResults)
      return ""
    return this.rawAnswer
  }

  Display()
  {
    Gui queryDisplay:New, +AlwaysOnTop 
    Gui queryDisplay:Add, ListView, x8 y8 w500 r20 +LV0x4000i, % this.LV_headers
    
    old_DefaultGui := A_DefaultGui
    Gui queryDisplay:Default
    for index,row in this.rows
    {
      data := []
      for key,value in row.data
      {
        data.Insert(value)
      }
      LV_Add("", data*)
    }

    Loop % this.colCount
    {
      LV_ModifyCol(A_Index, "AutoHdr")
    }

    Gui %old_DefaultGui%:Default
    Gui queryDisplay:Show
  }

  Data()
  {
    return this.rows
  }
}

Class QueryRow {
  __New(columnHeaders, rowData)
  {
    this.data := Object()
    for index,header in columnHeaders
    {
      StringLower, header, header
      this.Set(header, rowData[index]) 
    }
  }

  Get(key)
  {
    StringLower, key, key
    return this.data[key]
  }

  Set(key, value)
  {
    StringLower, key, key
    this.data[key] := value
    return this.data[key]
  }
}

Class Query_VerifyPO extends Query {
  __New(ponum)
  {
    qStr := "SELECT STATUS FROM PORDER WHERE PONUM='PO" ponum "';"
    base.__New(qStr)
  }

  IsPrinted()
  {
    ret := false
    if (this.hasResults)
    {
      ret := (this.rows[1].Get("status") == "Printed")
    }
    return ret
  }
}

Class Query_PODetails extends Query {
  __New(ponum)
  {
    qStr := "SELECT LINE, REFERENCE, QTY, QTYR, MANUPARTNO FROM PODETL WHERE PONUM='PO" ponum "';"
    base.__New(qStr)
  }

  Run()
  {
    base.Run()
    this.FormatData()
    return this.rows
  }

  FormatData()
  {
    if (this.hasResults) {
      for index,row in this.rows
      {
        line := this.rows[index].Get("line")
        line := Format("{:d}", line)
        this.rows[index].Set("line", line)
      }
    }
  }
}

Class Query_VerifyReceived extends Query {
  __New(partNum, lotNum, qty)
  {
    qStr := "SELECT itemcode, lotno, qty FROM itemh WHERE itemcode='" partNum "' AND lotno='" lotnum "' AND qty=" qty ";"
    base.__New(qStr)
  }
}