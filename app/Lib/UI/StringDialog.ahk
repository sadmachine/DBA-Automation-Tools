; === Script Information =======================================================
; Name .........: UI.StringDialog
; Description ..: A dialog for handling string inputs
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 05/18/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: StringDialog.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (05/18/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; UI.StringDialog
class StringDialog extends UI.BaseDialog
{
    define()
    {
        this.addControl("Edit", "w200")
    }
}