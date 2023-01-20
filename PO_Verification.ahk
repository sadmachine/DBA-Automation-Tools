#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include src/Bootstrap.ahk

receivingController := new Controllers.Receiving()

receivingController.bootstrapReceiver(new Models.Receiver())

receivingController.displayReceivingResults()

ExitApp

; --- Functions ----------------------------------------------------------------

