#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

#Include <Excel>

xlReceivingLog := new Excel("C:\Users\austi\Documents\Pragmatic\Projects\DBA-Automation-Tools\dist\modules\data\templates\Incoming Inspection Log.xlsx", true)
;xlApp := ComObjCreate("Excel.Application")
;xlApp.Visible := true ; This line is for testing only. It can be removed so Excel remains invisible.
;CurrWbk := xlApp.Workbooks.Open("C:\Users\austi\Documents\Pragmatic\Projects\DBA-Automation-Tools\dist\modules\data\templates\Incoming Inspection Log.xlsx") ; Open the master file
CurrSht := CurrWbk.Sheets(1)
; Get the last cell in column A, then save a reference to the cell next to it (column B)
LastCell := CurrSht.Cells(xlApp.Rows.Count, 1).End(xlUp := -4162).Offset(1, 0)
MsgBox % LastCell.Address

;lastRow := xlReceivingLog["A2"]
;MsgBox % lastRow.Text
;emptyRow := lastRow.Offset(1,0).Row
;lastRow.Copy()
;emptyRow.PasteSpecial(xlPasteFormats := -4122)
;MsgBox % emptyRow.Cells(1,1).Address
;emptyRow.Cells(1, 1).Value := "Test"
;MsgBox % "Wait"