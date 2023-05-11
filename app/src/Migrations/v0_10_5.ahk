; === Script Information =======================================================
; Name .........: Migration 0.10.5
; Description ..: Migration to version 0.10.5
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 05/08/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: v0.10.5.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (05/08/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Migrations.v0_10_5
class v0_10_5 extends Migrations.BaseMigration
{
    ; --- Include Change Files -------------------------------------------------
    class Install {
        class CreateDirectories {

        }
    }

    class Update {

    }

    ; --- Methods --------------------------------------------------------------

    getVersion()
    {
        return "0.10.5"
    }

    doInstall()
    {

    }

    doUpdate()
    {

    }
}