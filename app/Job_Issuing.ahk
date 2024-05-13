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
; Revision 2 (05/13/2024)
; * Update job issuing order to include job issuing "pick list"
; * Process also allows for picking from one job multiple times now
; 
; === TO-DOs ===================================================================
; ==============================================================================

#Include src/Bootstrap.ahk



try {
    jobIssuingController := new Controllers.JobIssuing()

    another := true
    jobIssuingController.getJob(new Models.JobIssue())

    while (another) {
        another := jobIssuingController.showJobIssuesList()

        if (!another) {
            break
        }

        jobIssuingController.getIssueDetails()

        jobIssuingController.automate()
    }

} catch e {
    @.friendlyException(e, true)
    jobIssuingController.cleanup()
}

#.log("app").info(A_LineFile, "Before ExitApp")

ExitApp

#If $["DEVELOPER_MODE"]
!`::DeveloperConsole()

; --- Functions ----------------------------------------------------------------
DeveloperConsole()
{
    Gui, devConsole:New, % "+ToolWindow +AlwaysOnTop", % "Developer Console"
    Gui, devConsole:Add, Button, gDoListVars, List Vars
    Gui, devConsole:Add, Button, x+5 gDoListLines, List Lines
    Gui, devConsole:Add, Button, x+5 gDoKeyHistory, Key History
    Gui, devConsole:Show
}

DoListVars()
{
    ListVars
}

DoListLines()
{
    ListLines
}

DoKeyHistory()
{
    KeyHistory
}