#SingleInstance, Force
#NoEnv
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include src/Bootstrap.ahk

try {
    receivingController := new Controllers.Receiving()

    receivingController.bootstrapReceiver(new Models.Receiver())

    receivingController.displayReceivingResults()
} catch e {
    @.friendlyException(e)
    receivingController.cleanup()
}

ExitApp

; --- Functions ----------------------------------------------------------------

