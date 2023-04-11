; === Script Information =======================================================
; Name .........: Models (top-level class)
; Description ..: A parent class for all model classes
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Models.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; TODO: Revisit names of models
; ==============================================================================
class Models {
    #Include "Models/DBA.ahk"
    #Include "Models/Receiver.ahk"
    #Include "Models/LotInfo.ahk"
}