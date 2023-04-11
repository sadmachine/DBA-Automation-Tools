; === Script Information =======================================================
; Name .........: File In Use Exception
; Description ..: Handles an exception where a file is in use
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/06/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: FileInUseException.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/06/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Core.FilesystemException
class FileInUseException extends Core.ExpectedException
{
    __New(where, message, data := "")
    {
        base.__New("FileInUseException", where, message, data)
    }
}