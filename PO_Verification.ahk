#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include <IniConfig>
#Include <ADOSQL>
#Include <Query>

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
    matching_lines := ""
    for n, row in results.rows
    {
        matching_lines .= Floor(row["line"]) ","
    }
    matching_lines := RTrim(matching_lines, ",")
    winId := results.display()
    WinWaitClose, % "ahk_id " winId
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
        InputBox, output, % "Enter " prompts[input_name], % "Enter " prompts[input_name],,260,130
        values[input_name] := output
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