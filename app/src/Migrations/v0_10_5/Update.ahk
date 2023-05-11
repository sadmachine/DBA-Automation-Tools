; === Script Information =======================================================
; Name .........: Install (0.10.5)
; Description ..: Installation changes for version 0.10.5 
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 05/09/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Update.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (05/09/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Migrations.v0_10_5.Install
class Install
{
    #Include src/Migrations/v0_10_5/Install/CreateDirectories.ahk
}