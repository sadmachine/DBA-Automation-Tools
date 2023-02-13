#NoEnv
#SingleInstance, Force
#Persistent
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

#Include <DBA>
#Include <UI>
#Include src/Config/All.ahk
#Include <Config>
#Include <#>

path := "C:\Users\austi"
path2 := "C:\Users\austi\test\test"

MsgBox,% RegExReplace(path,"[^\\]+\\?$")
MsgBox,% RegExReplace(path2,"[^\\]+\\?$")
IniRead, globalConfigLocation, % #.Path.parseDirectory(A_LineFile) "/dist/modules/config.ini", % "location", % "global"
IniRead, localConfigLocation, % #.Path.parseDirectory(A_LineFile) "/dist/modules/config.ini", % "location", % "local"
Config.setLocalConfigLocation(localConfigLocation)
Config.setGlobalConfigLocation(globalConfigLocation)
Config.register(new DatabaseGroup())
Config.register(new ReceivingGroup())
Config.initialize()

settings := new UI.Settings("Test settings")
settings.Show()