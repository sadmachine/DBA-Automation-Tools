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
; Revision 3 (04/19/2023)
; * Update for ahk v2
; 
; === TO-DOs ===================================================================
; ==============================================================================
class Env
{
    static data := Map()
    static __Item[name] 
    {
        get {
            return this.get(name)
        } 
        set {
            this.set(name, value)
        } 
    }

    static get(key, default := "")
    {
        if (!this.data.Has(key)) {
            return default
        }
        return this.data[key]
    }

    static set(key, value)
    {
        this.data[key] := value
    }
}