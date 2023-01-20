#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include <IniConfig>
#Include <Config>
#Include <ADOSQL>
#Include <Query>
#include <UI>
#Include <@File>
#Include <String>
#Include <DBA>
#Include <Excel>
#Include src/Models.ahk
#Include src/Controllers.ahk
#Include src/Views.ahk
#Include src/Actions.ahk
#Include src/Config/All.ahk

Config.BaseField.defaultRequirementsValue := true
IniRead, globalConfigLocation, % @File.parseDirectory(A_LineFile) "/config.ini", % "location", % "global"
IniRead, localConfigLocation, % @File.parseDirectory(A_LineFile) "/config.ini", % "location", % "local"
Config.setLocalConfigLocation(localConfigLocation)
Config.setGlobalConfigLocation(globalConfigLocation)
Config.register(new DatabaseGroup())
Config.register(new ReceivingGroup())
Config.initialize()

receivingController := new Controllers.Receiving()

receivingController.bootstrapReceiver(new Models.Receiver())

receivingController.displayReceivingResults()

ExitApp

; --- Functions ----------------------------------------------------------------

