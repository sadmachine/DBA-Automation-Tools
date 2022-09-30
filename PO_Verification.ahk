#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include <IniConfig>
#Include <ADOSQL>
#Include <Query>
#include <UI>
#Include <Utils>
#Include <DBA>

FONT_OPTIONS := {options: "s12", face: ""}

config := new IniConfig("po_verification")

if !(config.exists()) {
    config.copyFrom("po_verification.default.ini")
}

input_order     := config.getSection("input_order")
prompts         := config.getSection("prompts")
readable_fields := config.getSection("readable_fields")
values          := {}

values := SolicitValues(input_order, prompts, readable_fields, FONT_OPTIONS)

DB := new DBConnection()
results := DB.query("SELECT status FROM porder WHERE ponum='" ToUpper(values["purchase_order_number"]) "';")

if (results.count() > 1)
{
    MsgBox % "More than 1 PO matches the PO # number entered, this must be an error."
    ExitApp
} 

if (!InStr("Open,Printed", results.row(0)["status"]))
{
    MsgBox % "The PO '" values["purchase_order_number"] "' has status '" results.row(0)["status"] "'. Status should be either 'Open' or 'Printed'"
    ExitApp
}

results := DB.query("SELECT line, reference AS part_number, qty, qtyr AS qty_received FROM podetl WHERE ponum='" values["purchase_order_number"] "' AND reference='" values["part_number"] "' AND qty-qtyr>='" values["quantity"] "';")

if (results.empty()) 
{
    MsgBox % "No parts matched the given criteria."
    ExitApp
}
else
{
    DisplayResults(results)
}

ExitApp

; Functions


SolicitValues(input_order, prompts, readable_fields, FONT_OPTIONS)
{
    values := {}
    for n, input_name in input_order
    {
        ib := new UI.InputBox(prompts[input_name])
        ib.setFont(FONT_OPTIONS["options"], FONT_OPTIONS["face"])
        result := ib.prompt()
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
    Gui, %DisplayResults%:Font, % FONT_OPTIONS.options, % FONT_OPTIONS.face
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
    has_cert := UI.MsgBox.YesNo("Does lot # " values["lot_number"] " have certification?", "", FONT_OPTIONS)
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

    another_lot := UI.MsgBox.YesNo("Add another lot/qty?", "", FONT_OPTIONS)
    while (another_lot.value == "Yes")
    {
        ib := new UI.InputBox(prompts["lot_number"])
        ib.setFont(FONT_OPTIONS["options"], FONT_OPTIONS["face"])
        lot_number := ib.prompt()
        if (lot_number.canceled) 
        {
            MsgBox % "You must supply another lot #, exiting..."
            ExitApp
        }
        ib := new UI.InputBox(prompts["quantity"])
        ib.setFont(FONT_OPTIONS["options"], FONT_OPTIONS["face"])
        qty := ib.prompt()
        if (qty.canceled) 
        {
            MsgBox % "You must supply another qty, exiting..."
            ExitApp
        }
        has_cert := UI.MsgBox.YesNo("Does lot # " lot_number.value " have certification?", "", FONT_OPTIONS)
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
        another_lot := UI.MsgBox.YesNo("Add another lot/qty?", "", FONT_OPTIONS)
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
