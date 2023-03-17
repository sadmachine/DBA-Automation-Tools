; === Script Information =======================================================
; Name .........: Queue Bootstrapping File
; Description ..: Responsible for registering queue handlers
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/16/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Queue.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/16/2023)
; * Added This Banner
; * Add Inspection Report queue handler
;
; === TO-DOs ===================================================================
; ==============================================================================

Queue.registerHandler("1" , ObjBindMethod(Actions.InspectionReport, "poll", #.Path.concat($.PROJECT_ROOT, "queue\inspection-reports")))