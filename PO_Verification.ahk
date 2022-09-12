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
results := DB.query("SELECT status FROM porder WHERE ponum='" values["purchase_order_number"] "';").data()

MsgBox % results.rawAnswer
MsgBox % ADOSQL_LastError ": " ADOSQL_LastQuery

for n, row in results
{
    output := ""
    for column, value in row
    {
        output .= column ": " value "`n"
    }
    MsgBox %output%
}

return

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