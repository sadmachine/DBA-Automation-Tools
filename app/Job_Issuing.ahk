; === Script Information =======================================================
; Name .........: Job Issuing
; Description ..: Handles the full Job Issuing process
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/14/2024
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Job_Issuing.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added this banner
;
; === TO-DOs ===================================================================
; ==============================================================================

#Include src/Bootstrap.ahk

try {
    jobIssuingController := new Controllers.JobIssuing()

    jobIssuingController.getInputs(new Models.JobIssue())

    jobIssuingController.automate()
} catch e {
    @.friendlyException(e)
    jobIssuingController.cleanup()
}

#.log("app").info(A_LineFile, "Before ExitApp")

ExitApp

; --- Functions ----------------------------------------------------------------

