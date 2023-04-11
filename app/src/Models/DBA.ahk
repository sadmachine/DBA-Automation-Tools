; === Script Information =======================================================
; Name .........: DBA Model parent class
; Description ..: The parent for all other DBA database models
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: DBA.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Models.DBA
class DBA {
    #Include "DBA/podetl.ahk"
    #Include "DBA/porder.ahk"
    #Include "DBA/item.ahk"
    #Include "DBA/locations.ahk"
}