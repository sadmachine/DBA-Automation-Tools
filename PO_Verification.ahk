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
#Include src/Models.ahk
#Include src/Controllers.ahk
#Include src/Views.ahk
#Include src/Actions.ahk

config := new IniConfig("po_verification")

if !(config.exists()) {
    config.copyFrom("po_verification.default.ini")
}

receivingController := new Controllers.Receiving()

receivingController.bootstrapReceiver(new Models.Receiver())

receivingController.displayReceivingResults()

ExitApp

; --- Functions ----------------------------------------------------------------

