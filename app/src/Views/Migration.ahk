; === Script Information =======================================================
; Name .........: Views.Installers (parent class)
; Description ..: A parent class for all installer views
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/09/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Installers.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/09/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Views.Migration
class Migration
{
    #Include src/Views/Migration/Base.ahk
    #Include src/Views/Migration/Client.ahk
}