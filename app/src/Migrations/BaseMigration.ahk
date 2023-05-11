; === Script Information =======================================================
; Name .........: Base Migration
; Description ..: Base Migration file
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 05/04/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Base.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (05/04/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Migrations.Base
class BaseMigration
{
    static statuses := ["pending", "started", "failed", "terminated", "completed"]

    install()
    {
        ; Perform fresh installation
    }

    update()
    {
        ; Perform update from the last version to this version
    }

    getVersionNumber()
    {
        ; return version number
    }
}