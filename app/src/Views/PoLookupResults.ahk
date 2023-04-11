; === Script Information =======================================================
; Name .........: PO Lookup Results
; Description ..: The GUI used to display results from a PO Lookup
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: PoLookupResults.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Views.ReceivingLookupResults
class PoLookupResults extends UI.Base
{
    __New(controller)
    {
        base.__New("PO Verification Results", "+AlwaysOnTop")
        this.controller := controller
    }

    display(receiver)
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
        this.Add("Edit", "ReadOnly x+5 yp-4 w102", receiver.lots[1].quantity)
        this.Add("Text", "x+10 ys+64 w50 Right", "Lot #:")
        this.Add("Edit", "ReadOnly x+5 yp-4 w200", receiver.lots[1].lotNumber)
        this.Add("GroupBox", "x8 w340 h236 Section", "Matching Lines:")
        columns := "Line|Part #|Qty|Qty Rcvd"
        columnCount := StrSplit(columns, "|").Count()
        ResultsListView := this.Add("ListView", "xs+4 ys+26 w330 h200", columns)
        this.Add("GroupBox", "xs+344 ys+0 w116 h236 Section", "Actions")
        ReceiveButton := this.Add("Button", "xs+6 ys+26 w102 Default", "Receive")
        this.controller.bind(ReceiveButton, "newReceivingTransaction")
        this.Default()

        for index,record in receiver.related["podetl"]
        {
            ResultsListView.Add("", Floor(record.line), Floor(record.reference), Floor(record.qty), Floor(record.qtyr))
        }

        Loop columnCount
        {
            ResultsListView.ModifyCol(A_Index, "AutoHdr")
        }

        ; Make sure first row is selected
        ResultsListView.Modify(1, "Focuse")
        ResultsListView.Modify(1, "Select")

        this.Show()
        ; this.FocusControl(ResultsListView)
        this.WaitClose()
    }

    getSelectedLine() {
        global
        this.Default()

        selected_row := ResultsListView.GetNext()
        lineNumber := ResultsListView.GetText(selected_row)
        this.Destroy()
        return lineNumber
    }
}