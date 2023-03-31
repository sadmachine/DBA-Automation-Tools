; === Script Information =======================================================
; Name .........: $ (dollar sign)
; Description ..: Global variable holder
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/12/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: $.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/12/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
class $
{
    __Get(key, default := "")
    {
        this.get(key, default)
    }

    get(key, default := "")
    {
        if (!this.hasKey(key)) {
            return default
        }
        return this[key]
    }
}