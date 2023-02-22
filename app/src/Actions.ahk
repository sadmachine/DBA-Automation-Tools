; === Script Information =======================================================
; Name .........: Actions (top-level class)
; Description ..: A parent class for all defined actions
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Actions.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
class Actions
{
    #Include src/Actions/Base.ahk
    #Include src/Actions/ReceivingTransaction.ahk
    #Include src/Actions/InspectionReport.ahk
    #Include src/Actions/ReceivingLog.ahk
    #Include src/Actions/PrintLabels.ahk
}