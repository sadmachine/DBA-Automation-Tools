#Include <UI>
class Results extends UI.Base
{
    __New()
    {
        base.__New("PO Verification Results", "hwndDisplayResults +AlwaysOnTop")
    }

    Show()
    {
        Global
        this.New()
        this.Font()
        Gui, %DisplayResults%:Add, GroupBox, Section h70 w800, Scanned Items
        Gui, %DisplayResults%:Add, Text, xs+8 ys+30, PO #:
        Gui, %DisplayResults%:Add, Edit, ReadOnly x+5 yp-4 w102, % values["purchase_order_number"]
        Gui, %DisplayResults%:Add, Text, x+10 ys+30, Part #:
        Gui, %DisplayResults%:Add, Edit, ReadOnly x+5 yp-4 w180, % values["part_number"]
        Gui, %DisplayResults%:Add, Text, x+10 ys+30, Lot #:
        Gui, %DisplayResults%:Add, Edit, ReadOnly x+5 yp-4 w180, % values["lot_number"]
        Gui, %DisplayResults%:Add, Text, x+10 ys+30, Quantity:
        Gui, %DisplayResults%:Add, Edit, ReadOnly x+5 yp-4 w82, % values["quantity"]
        Gui, %DisplayResults%:Add, GroupBox, xm w650 h436 Section, Matching Lines:
        Gui, %DisplayResults%:Add, ListView, xs+4 ys+26 w642 h400 hwndResultsListView, % results.LV_Headers
        Gui, %DisplayResults%:Add, GroupBox, xs+654 ys+0 w146 h436 Section, Actions
        Gui, %DisplayResults%:Add, Button, gReceiveSelectedLine xs+6 ys+26 w132 Default, Receive
        Gui, %DisplayResults%:Default

        for index,row in results.rows
        {
            data := []
            for header,record in row
            {
                data[results.headerIndex[header]] := Floor(record)
            }
            LV_Add("", data*)
        }

        Loop % results.colCount
        {
            LV_ModifyCol(A_Index, "AutoHdr")
        }

        ; Make sure first row is selected
        LV_Modify(1, "Select")

        Gui, %DisplayResults%:Show
        GuiControl, Focus, % ResultsListView
        WinWaitClose, % "PO Verification Results"
        return DisplayResults
    }
}