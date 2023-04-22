; === Script Information =======================================================
; Name .........: Config.StringField
; Description ..: Field for inputing string values
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/19/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: StringField.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/19/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; Config.StringField
class StringField extends Config.BaseField
{
    min := ""
    max := ""

    __New(label, scope := "", options := Map())
    {
        if (options.Has("min")) {
            this.min := options["min"]
        }
        if (options.Has("max")) {
            this.max := options["max"]
        }

        super.__New("string", label, scope, options)
    }
}