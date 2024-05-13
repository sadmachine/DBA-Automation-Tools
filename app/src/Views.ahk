; === Script Information =======================================================
; Name .........: Views (top-level class)
; Description ..: A parent class for view classes
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Views.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; TODO - Add more views
; ==============================================================================
#Include <UI>
class Views
{
    #Include src/Views/PoLookupResults.ahk
    #Include src/Views/JobIssuesList.ahk
}