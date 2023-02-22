; === Script Information =======================================================
; Name .........: porder (DBA Table)
; Description ..: Acts as a layer to interface with the "porder" DBA Table
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: porder.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Models.DBA.porder
class porder extends DBA.ActiveRecord
{
    _pk := "ponum"
    _tableName := "porder"
}