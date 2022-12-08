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
        this.Add("GroupBox", "Section h70 w800", "Scanned Items")
        this.Add("Text", "xs+8 ys+30", "PO #:")
        this.Add("Edit", "ReadOnly x+5 yp-4 w102", receiver.poNumber)
        this.Add("Text", "x+10 ys+30", "Part #:")
        this.Add("Edit", "ReadOnly x+5 yp-4 w180", receiver.partNumber)
        this.Add("Text", "x+10 ys+30", "Lot #:")
        this.Add("Edit", "ReadOnly x+5 yp-4 w180", receiver.lotNumbers[1])
        this.Add("Text", "x+10 ys+30", "Quantity:")
        this.Add("Edit", "ReadOnly x+5 yp-4 w82", receiver.quantities[1])
        this.Add("GroupBox", "xm w650 h436 Section", "Matching Lines:")
        ResultsListView := this.Add("ListView", "xs+4 ys+26 w642 h400", poResults.lvHeaders)
        this.Add("GroupBox", "xs+654 ys+0 w146 h436 Section", "Actions")
        ReceiveButton := this.Add("Button", "xs+6 ys+26 w132 Default", "Receive")
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
        this.receiver.PullAdditionalInfo()
        this.Destroy()

        transaction := new Receiving.Transaction(this.receiver)
    }
}