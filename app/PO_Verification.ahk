; === Script Information =======================================================
; Name .........: PO Verification
; Description ..: Handles the full PO Verification Process
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: PO_Verification.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added this banner
;
; === TO-DOs ===================================================================
; ==============================================================================

#Include "src/Bootstrap.ahk"

try {
    receivingController := new Controllers.Receiving()

    receivingController.bootstrapReceiver(new Models.Receiver())

    receivingController.displayReceivingResults()
} catch Any as e {
    Core.friendlyException(e)
    receivingController.cleanup()
}

Lib.log("app").info(A_LineFile, "Before ExitApp")

ExitApp()

; --- Functions ----------------------------------------------------------------

