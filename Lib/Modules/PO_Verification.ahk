#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include ../Config.ahk

config := Config("receiving.po_verification")

if !(config.exists()) {
    config.set()
}




; Functions

SetupBasicConfig(config)
{
    config.set("po_num", "1", "items")
}