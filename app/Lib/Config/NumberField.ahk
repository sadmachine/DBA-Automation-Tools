; === Script Information =======================================================
; Name .........: Config.NumberField
; Description ..: Field for handling number inputs
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/19/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: NumberField.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/19/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; Config.NumberField
class NumberField extends Config.BaseField
{
    min := ""
    max := ""

    __New(label, scope := "", options := Map())
    {
        super.__New("number", label, scope, options)
        if (options.Has("min")) {
            this.min := options["min"]
        } else {
            this.min := -2147483648
        }
        if (options.Has("max")) {
            this.max := options["max"]
        } else {
            this.max := 2147483647
        }
    }
}