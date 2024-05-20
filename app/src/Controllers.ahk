; === Script Information =======================================================
; Name .........: Controllers (top-level class)
; Description ..: A parent class for all controller classes
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Controllers.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
class Controllers
{
    #Include src/Controllers/Base.ahk
    #Include src/Controllers/Receiving.ahk
    #Include src/Controllers/JobIssuing.ahk
    #Include src/Controllers/JobIssuesReport.ahk
}