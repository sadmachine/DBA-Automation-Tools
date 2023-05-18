; === Script Information =======================================================
; Name .........: UI.NumberDialog
; Description ..: A dialog for handling number inputs
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 05/18/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: NumberDialog.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (05/18/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; UI.NumberDialog
class NumberDialog extends UI.BaseDialog
{
    define()
    {
        if (!this.data.hasKey("min") || !this.data.hasKey("max")) {
            throw new @.ProgrammerException(A_ThisFunc, "Either 'min' or 'max' is not defined")
        }
        options := "Range" this.data["min"] "-" this.data["max"] " 0x80 "
        this.addControl("Edit", "w120")
        this.addControl("UpDown", options)
    }
}