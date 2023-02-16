#Include src/Bootstrap.ahk

try {
    receivingController := new Controllers.Receiving()

    receivingController.bootstrapReceiver(new Models.Receiver())

    receivingController.displayReceivingResults()
} catch e {
    @.friendlyException(e)
    receivingController.cleanup()
}

#.Logger.info(A_LineFile, "Before ExitApp")

ExitApp

; --- Functions ----------------------------------------------------------------

