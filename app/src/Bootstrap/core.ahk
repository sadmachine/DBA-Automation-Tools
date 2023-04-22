; === Script Information =======================================================
; Name .........: Core
; Description ..: A file containing some core declarations (exception handling)
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/15/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Constants.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/15/2023)
; * Added This Banner
;
; Revision 2 (04/21/2023)
; * Update for ahk v2
; 
; === TO-DOs ===================================================================
; ==============================================================================

; Core.registerExceptionHandler()

Env["PROJECT_ROOT"] := ""
if (InStr("DBA AutoTools.exe,QueueManager.exe,Settings.exe", A_ScriptName)) {
    Env["PROJECT_ROOT"] := Lib.Path.normalize(A_ScriptDir)
} else {
    Env["PROJECT_ROOT"] := Lib.Path.parentOf(Lib.Path.parentOf(A_ScriptDir))
}