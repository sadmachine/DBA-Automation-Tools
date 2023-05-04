; === Script Information =======================================================
; Name .........: Module Object
; Description ..: Holds basic attributes of a Module
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: ModuleObj.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; Revision 2 (04/30/2023)
; * Add additional logging
;
; === TO-DOs ===================================================================
; TODO - Convert this into a model class
; ==============================================================================
class ModuleObj
{
    __New(title, section_title, file)
    {
        this.title := title
        this.section_title := section_title
        this.file := file
        #.log("app").info(A_ThisFunc, "Module: {" section_title ", " title ", " file "}")
    }
}