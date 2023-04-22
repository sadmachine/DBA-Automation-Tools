; === Script Information =======================================================
; Name .........: Config.PathField
; Description ..: Field for handling Path (file/directory) inputs
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/19/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: PathField.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/19/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; Config.PathField
class PathField extends Config.BaseField
{
    __New(label, pathType := "file", scope := "", options := Map())
    {
        this.pathType := Str.toLower(pathType)

        super.__New("path", label, scope, options)
    }
}