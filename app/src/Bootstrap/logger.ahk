; === Script Information =======================================================
; Name .........: Logger Boostrap File
; Description ..: Responsible for bootstrapping the logger class
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/15/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Logger.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/15/2023)
; * Added This Banner
;
; Revision 2 (03/27/2023)
; * Use new global var syntax
;
; === TO-DOs ===================================================================
; ==============================================================================
#.Logger.addChannel("app", #.Path.concat($["PROJECT_ROOT"], "modules"), "application.log")
#.Logger.addChannel("queue", #.Path.concat($["PROJECT_ROOT"], "modules"), "queue.log")
#.log("app").info(A_LineFile, "Finished Bootstrapping '" A_ScriptName "'", "")