; === Script Information =======================================================
; Name .........: Constants
; Description ..: A file containing all runtime constant declarations
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
; === TO-DOs ===================================================================
; ==============================================================================
$.PROJECT_ROOT := ""
if (InStr("DBA AutoTools.exe,QueueManager.exe,Settings.exe,Installer.exe", A_ScriptName)) {
    $.PROJECT_ROOT := #.Path.normalize(A_ScriptDir)
} else {
    $.PROJECT_ROOT := #.Path.parentOf(A_ScriptDir)
}

$.QUEUE_PATH := #.Path.concat($.PROJECT_ROOT, "queue")