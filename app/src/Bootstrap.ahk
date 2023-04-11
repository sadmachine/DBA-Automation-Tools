; === Script Information =======================================================
; Name .........: Bootstrap Script
; Description ..: Includes common libraries/files and configures them
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Bootstrap.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; Revision 2 (03/31/2023)
; * Bootstrap logging earlier
;
; === TO-DOs ===================================================================
; TODO - Clean/Organize better
; ==============================================================================
#SingleInstance Force
SendMode("Input")
SetWorkingDir(A_ScriptDir)

#Include "../Autoload.ahk"

#Include "Bootstrap/core.ahk"
#Include "Bootstrap/constants.ahk"
#Include "Bootstrap/logger.ahk"
#Include "Bootstrap/ui.ahk"
#Include "Bootstrap/config.ahk"
#Include "Bootstrap/database.ahk"
#Include "Bootstrap/queue.ahk"
