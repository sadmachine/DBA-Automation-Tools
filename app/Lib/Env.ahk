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
; Revision 2 (03/31/2023)
; * Add methods for getting global vars with defaults
;
; === TO-DOs ===================================================================
; ==============================================================================
class Env
{
    __Get(key, default := "")
    {
        this.get(key, default)
    }

    get(key, default := "")
    {
        if (!this.Has(key)) {
            return default
        }
        return this[key]
    }
}