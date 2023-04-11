; === Script Information =======================================================
; Name .........: Queue File Drivers parent
; Description ..: A parent class to contain file drivers
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/20/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: FileDrivers.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/20/2023)
; * Added This Banner
;
; Revision 2 (03/23/2023)
; * Include file driver instances
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Lib.Queue.FileDrivers
class FileDrivers
{
    #Include "FileDrivers\Base.ahk"
    #Include "FileDrivers\Ini.ahk"
}