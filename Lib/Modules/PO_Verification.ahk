#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include ../IniConfig.ahk

config := new IniConfig("po_verification")

if !(config.exists()) {
    SetupBasicConfig(config)
}


return

; Functions

SetupBasicConfig(config)
{
    MsgBox % config.getConfigPath()
    config.set("purchase_order_number", "1", "inputs")
    config.set("part_number", "1", "inputs")
    config.set("quantity", "1", "inputs")

    config.set("verify", true, "general")
}