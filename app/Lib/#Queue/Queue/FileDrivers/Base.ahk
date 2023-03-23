; === Script Information =======================================================
; Name .........: Base File Driver
; Description ..: A base file driver for other file drivers to extend
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/20/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Base.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/20/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; #.Queue.FileDrivers.Base
class Base
{
    basePath := ""
    __New(path)
    {
        this.basePath := path
    }

    createFile(namespace, data)
    {

    }

    readFiles(namespace)
    {

    }
}