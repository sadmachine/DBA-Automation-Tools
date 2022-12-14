#Include <UI>
class Results extends UI.Base
{
    __New()
    {
        base.__New("PO Verification Results", "+AlwaysOnTop")
    }

    Display(receiver, poResults)
    {
        Global
        this.receiver := receiver
        this.ApplyFont()
        this.Margin(4)
        this.Add("GroupBox", "Section x8 h100 w460", "Scanned Items")
        this.Add("Text", "xs+8 ys+30 w64 Right", "PO #:")
        this.Add("Edit", "ReadOnly x+5 yp-4 w102", receiver.poNumber)
        this.Add("Text", "x+10 ys+30 w50 Right", "Part #:")
        this.Add("Edit", "ReadOnly x+5 yp-4 w200", receiver.partNumber)
        this.Add("Text", "xs+8 ys+64 w64 Right", "Quantity:")
        this.Add("Edit", "ReadOnly x+5 yp-4 w102", receiver.quantities[1])
        this.Add("Text", "x+10 ys+64 w50 Right", "Lot #:")
        this.Add("Edit", "ReadOnly x+5 yp-4 w200", receiver.lotNumbers[1])
        this.Add("GroupBox", "x8 w340 h236 Section", "Matching Lines:")
        header := poResults.lvHeaders
        header := StrReplace(header, "PART NUMBER", "PART #")
        header := StrReplace(header, "QTY RECEIVED", "QTY RCVD")
        ResultsListView := this.Add("ListView", "xs+4 ys+26 w330 h200", header)
        this.Add("GroupBox", "xs+344 ys+0 w116 h236 Section", "Actions")
        ReceiveButton := this.Add("Button", "xs+6 ys+26 w102 Default", "Receive")
        this.bind(ReceiveButton, "NewTransaction")
        this.Default()

        for index,row in poResults.rows
        {
            data := []
            for header,record in row
            {
                data[poResults.headerIndex[header]] := Floor(record)
            }
            LV_Add("", data*)
        }

        Loop % poResults.colCount
        {
            LV_ModifyCol(A_Index, "AutoHdr")
        }

        ; Make sure first row is selected
        LV_Modify(1, "Select")

        this.Show()
        this.FocusControl(ResultsListView)
        this.WaitClose()
        return DisplayResults
    }

    NewTransaction()
    {
        global
        this.Default()

        selected_row := LV_GetNext()
        LV_GetText(lineNumber, selected_row)
        this.receiver.lineReceived := lineNumber
        this.Destroy()

        transaction := new Receiving.Transaction(this.receiver)
    }
}