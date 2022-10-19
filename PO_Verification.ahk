#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include <IniConfig>
#Include <ADOSQL>
#Include <Query>
#include <UI>
#Include <File>
#Include <String>
#Include <DBA>
#Include <Excel>
#Include src/Receiving.ahk

FONT_OPTIONS := {options: "s12", fontName: ""}

UI.InputBox.defaultFontSettings := FONT_OPTIONS

config := new IniConfig("po_verification")

if !(config.exists()) {
    config.copyFrom("po_verification.default.ini")
}

receiver := new Receiving.Receiver()

receiver.RequestPONumber()
receiver.RequestPartNumber()
receiver.RequestLotNumber()
receiver.RequestQuantity()

verifier := new Receiving.Verify()

results := verifier.GetResults()

DisplayResults(results)

ExitApp

; --- Functions ----------------------------------------------------------------

SolicitValues(input_order, prompts, readable_fields)
{
    values := {}
    for n, input_name in input_order
    {
        result := UI.InputBox(prompts[input_name])
        if (result.canceled)
        {
            MsgBox % "You must supply a " readable_fields[input_name] " to continue. Exiting..."
            ExitApp
        }
        values[input_name] := result.value
    }
    return values
}

DisplayVerifyScreen()
{
    Global
    Gui, verify:New, AlwaysOnTop, Verify Inputs
    for n, input_name in input_order
    {
        Gui, verify:Add, Text, w50 xm, % prompts[input_name]
        Gui, verify:Add, Edit, ReadOnly yp-4 x+5, % values[input_name]
    }
    Gui, verify:Add, Button, gVerify Default,
    Gui, verify:Show
}

DisplayResults(results)
{
    Global
    Gui, New, hwndDisplayResults +AlwaysOnTop, PO Verification Results
    Gui, %DisplayResults%:Font, % FONT_OPTIONS.options, % FONT_OPTIONS.fontName
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

ReceiveSelectedLine(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:="")
{
    Global

    lot_numbers := []
    quantities := []
    locations := []
    mb := new UI.MsgBox("Does lot # " values["lot_number"] " have certification?")
    has_cert := mb.YesNo()
    if (has_cert.value == "Yes")
    {
        location := "Received"
    }
    else
    {
        locaiton := "QA Hold"
    }

    Gui, %DisplayResults%:Default

    selected_row := LV_GetNext()
    LV_GetText(line_number, selected_row)
    index_number := GetLineNumberIndex(line_number)

    Gui, %DisplayResults%:Destroy

    WinActivate, % DBA.Windows.Main
    WinWaitActive, % DBA.Windows.Main,, 5
    if ErrorLevel
    {
        MsgBox % "Main window never became active"
    }

    Send {Alt Down}pr{Alt Up}
    WinWaitActive, % DBA.Windows.POReceiptLookup,, 5
    if ErrorLevel
    {
        MsgBox % "PO Receipt Lookup never became active"
    }

    Send % values["purchase_order_number"]
    Sleep 500
    Send {Enter}

    WinWaitActive, % DBA.Windows.POReceipts,, 5
    if ErrorLevel
    {
        MsgBox % "PO Receipts never became active"
    }

    position := index_number - 1
    Loop % position
    {
        Send {Down}
    }

    Send {Tab}
    Sleep 100
    Send {Tab}
    ReceiveQtyAndLot(values["quantity"], values["lot_number"], location)

    lot_numbers.push(values["lot_number"])
    quantities.push(values["quantity"])
    locations.push(location)

    mb := new UI.MsgBox("Add another lot/qty?")
    another_lot := mb.YesNo()
    while (another_lot.value == "Yes")
    {
        ib := new UI.InputBox(prompts["lot_number"])
        lot_number := ib.prompt()
        if (lot_number.canceled)
        {
            MsgBox % "You must supply another lot #, exiting..."
            ExitApp
        }
        ib := new UI.InputBox(prompts["quantity"])
        qty := ib.prompt()
        if (qty.canceled)
        {
            MsgBox % "You must supply another qty, exiting..."
            ExitApp
        }
        mb := new UI.MsgBox("Does lot # " values["lot_number"] " have certification?")
        has_cert := mb.YesNo()
        if (has_cert.value == "Yes")
        {
            location := "Received"
        }
        else
        {
            location := "QA Hold"
        }
        WinActivate, % DBA.Windows.POReceipts
        WinWaitActive, % DBA.Windows.POReceipts,, 5
        if ErrorLevel
        {
            MsgBox % "PO Receipts never became active"
        }
        Send {Down}
        ReceiveQtyAndLot(qty.value, lot_number.value, location)
        lot_numbers.push(lot_number.value)
        quantities.push(qty.value)
        locations.push(location)
        mb := new UI.MsgBox("Add another lot/qty?")
        another_lot := mb.YesNo()
    }

    WinActivate, % DBA.Windows.POReceipts
    WinWaitActive, % DBA.Windows.POReceipts,, 5
    if ErrorLevel
    {
        MsgBox % "PO Receipts never became active, exiting"
        ExitApp
    }
    Send {Alt Down}u{Alt Up}

    exists := FileExist("data/Receiving Log.csv")
    file := FileOpen("data/Receiving Log.csv", "a")
    if (!exists)
    {
        file.WriteLine("Date,Time,PO#,Part#,Lot#,Qty,Location,Inspection#")
    }
    for n, quantity in quantities
    {
        FormatTime, datestr,, MM/dd/yyyy
        FormatTime, timestr,, HH:mm:ss
        inspection_number := config.get("inspection.last_number") + 1
        file.WriteLine(datestr "," timestr "," values["purchase_order_number"] "," values["part_number"] "," lot_numbers[n] "," quantities[n] "," locations[n] "," inspection_number)
        config.set("inspection.last_number", inspection_number)
    }
    file.Close()

    WinClose, % DBA.Windows.POReceipts
    WinWaitClose, % DBA.Windows.POReceipts,, 5
    if ErrorLevel
    {
        MsgBox % "PO Receipts never closed, exiting"
        ExitApp
    }
}

ReceiveQtyAndLot(qty, lot_number, location)
{
    Send {Home}
    Send % qty
    Send {Enter}
    Send {End}
    Send % lot_number
}

GetLineNumberIndex(line_to_find)
{
    Global
    open_lines := DB.query("SELECT line FROM podetl WHERE ponum='" values["purchase_order_number"] "' AND qty-qtyr>='" values["quantity"] "' AND closed IS NULL ORDER BY line ASC;")
    ; TODO: Error message if empty
    for n, row in open_lines.data()
    {
        cur_line := Floor(row["LINE"])
        if (line_to_find == cur_line)
        {
            return n
        }
    }
}

CreateNewInspectionReport(part_number, lot_number, part_description, po_number, vendor_name, quantity, quantity_received)
{
    inspectionConfig := new IniConfig("inspection_report")
    if (!inspectionConfig.exists()) {
        inspectionConfig.copyFrom("inspection_report.default.ini")
    }
    template := inspectionConfig.get("file.template")
    fields := inspectionConfig.getSection("fields")
    destination := inspectionConfig.get("file.destination")
    inspection_number := (inspectionConfig.get("file.last_num") + 1)
    inspectionConfig.set("file.last_num", inspection_number)
    filepath := RTrim(destination, "/") "/" inspection_number ".xlsx"
    MsgBox % template " " filepath
    FileCopy, % template, % filepath

    iReport := new Excel(File.getFullPath(filepath), true)

    iReport.range["C2"].Value := inspection_number
    iReport.range["C4"].Value := part_number
    iReport.range["C5"].Value := part_description
    iReport.range["C6"].Value := lot_number
    iReport.range["H3"].Value := po_number
    iReport.range["H4"].Value := vendor_name
    iReport.range["C10"].Value := quantity
    iReport.range["H10"].Value := quantity_received
    iReport.Save()
    iReport.Quit()

    MsgBox % "Wait"
}
