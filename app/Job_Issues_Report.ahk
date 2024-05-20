; === Script Information =======================================================
; Name .........: Job Issues Report
; Description ..: Outputs a PDF report of all job issues for the given job #
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 05/16/2024
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Job_Issues_Report.ahk
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
    jobIssuesReportController := new Controllers.JobIssuesReport()

    another := true
    jobIssuesReportController.getJob()
    jobIssuesReportController.gatherData()
    jobIssuesReportController.outputToPdf()
    jobIssuesReportController.displayPdf()

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