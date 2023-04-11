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
    #Include "Actions/Base.ahk"
    #Include "Actions/ReceivingTransaction.ahk"
    #Include "Actions/InspectionReport.ahk"
    #Include "Actions/ReceivingLog.ahk"
    #Include "Actions/PrintLabels.ahk"
}