; === Script Information =======================================================
; Name .........: Models.Migration
; Description ..: Represents data needed for a version migration process
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/22/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Installation.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/22/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Models.Migration
class Migration
{
    path := ""
    log := ""

    __New(path) {
        this.path := path
    }

    log(str, prependDateTime := true)
    {
        str := Trim(str, " `n`t") "`n"
        if (prependDateTime) {
            FormatTime, dateAndTime,, % "yyyy-MM-dd HH:mm:ss"
            str := dateAndTime " " str
        }
        this.log .= str
    }
}