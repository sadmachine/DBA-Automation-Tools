; === Script Information =======================================================
; Name .........: DateField
; Description ..: Field for entering date values
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/19/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: DateField.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/19/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; Config.DateField
class DateField extends Config.BaseField
{

    __New(label, scope := "", options := Map())
    {
        super.__New("date", label, scope, options)
    }
}