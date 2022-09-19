#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include <IniConfig>
#Include <ADOSQL>
#Include <Query>
#include <UI/InputBox>

config := new IniConfig("po_verification")

if !(config.exists()) {
    SetupBasicConfig(config)
}

input_order := config.getSection("input_order")
prompts     := config.getSection("prompts")
values      := {}

GetAllInitialValues()

DB := new DBConnection()
results := DB.query("SELECT status FROM porder WHERE ponum='" values["purchase_order_number"] "';")

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

results := DB.query("SELECT line, reference, qty, qtyr FROM podetl WHERE ponum='" values["purchase_order_number"] "' AND reference='" values["part_number"] "' AND qty-qtyr>='" values["quantity"] "';")

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

SetupBasicConfig(config)
{
    MsgBox % config.getConfigPath()

    config.setSection("input_order", { 1: "purchase_order_number"
                                     , 2: "part_number"
                                     , 3: "quantity" })

    config.setSection("prompts", { purchase_order_number : "PO #"
                                 , part_number           : "Part #"
                                 , quantity              : "Quantity"})

    config.setSection("general", { "verify": true })
}

GetAllInitialValues()
{
    Global
    for n, input_name in input_order
    {
        result := InputBox.prompt("Enter " prompts[input_name])
        if (result.canceled)
        {
            MsgBox % "You must supply a " prompts[input_name] " to continue. Exiting..."
            ExitApp
        }
        values[input_name] := result.value
    }
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
    Gui, %DisplayResults%:Add, GroupBox, Section w400, Scanned Items
    Gui, %DisplayResults%:Add, Text, xs+8 ys+26, PO#:
    Gui, %DisplayResults%:Add, Edit, ReadOnly x+5 yp-4 w62, % values["purchase_order_number"]
    Gui, %DisplayResults%:Add, Text, x+10 ys+26, Part #:
    Gui, %DisplayResults%:Add, Edit, ReadOnly x+5 yp-4 w120, % values["part_number"]
    Gui, %DisplayResults%:Add, Text, x+10 ys+26, Quantity:
    Gui, %DisplayResults%:Add, Edit, ReadOnly x+5 yp-4 w62, % values["quantity"]
    Gui, %DisplayResults%:Add, GroupBox, xm w400 r11 Section, Matching Lines:
    Gui, %DisplayResults%:Add, ListView, xs+4 ys+20 w392 r10 hwndResultsListView +LV0x4000i, % results.LV_Headers
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

    Gui, %DisplayResults%:Show
    GuiControl, Focus, % ResultsListView
    WinWaitClose, % "PO Verification Results"
    return DisplayResults
}