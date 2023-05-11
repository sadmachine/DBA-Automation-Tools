; === Script Information =======================================================
; Name .........: Base Change
; Description ..: Base class for all change classes
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 05/08/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: BaseChange.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (05/08/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Migrations.BaseChange
class BaseChange
{
    static statuses := ["pending", "started", "failed", "terminated", "completed"]
    static status := "pending"

    do()
    {

    }

    undo()
    {

    }
}