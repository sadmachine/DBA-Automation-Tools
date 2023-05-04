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
#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

#Include src/Autoload.ahk

#Include src/Bootstrap/core.ahk
#Include src/Bootstrap/constants.ahk
#Include src/Bootstrap/logger.ahk
#Include src/Bootstrap/ui.ahk
#Include src/Bootstrap/config.ahk
#Include src/Bootstrap/database.ahk
#Include src/Bootstrap/queue.ahk
