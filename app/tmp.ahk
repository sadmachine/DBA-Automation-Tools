; === Script Information =======================================================
; Name .........: Temporary scripts
; Description ..: A file used for trying things out and testing
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: tmp.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
#Include src/Bootstrap.ahk

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