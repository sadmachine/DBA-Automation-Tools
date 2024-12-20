; === Script Information =======================================================
; Name .........: Temporary scripts
; Description ..: A file used for trying things out and testing
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: tmp.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
#Include src/Autoload.ahk

location := "20-Z"

obj := {"locid=": location, "test>": "test"}

for field, value in obj
{
    MsgBox % field value
}