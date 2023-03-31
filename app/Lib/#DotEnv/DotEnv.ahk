; === Script Information =======================================================
; Name .........: DotEnv
; Description ..: Handles reading from .env files
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/31/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: DotEnv.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/31/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; TODO - Make more robust and validate keys/values
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; #.DotEnv
class DotEnv
{
    filepath := ""

    __New(filepath)
    {
        if (!FileExist(filepath)) {
            throw new @.ProgrammerException(A_ThisFunc, "DotEnv Filepath did not exist", {filepath: filepath})
        }
        this.filepath := filepath
    }

    toObject()
    {
        ret := {}
        Loop, Read, % this.filepath
        {
            line := Trim(A_LoopReadLine)

            if (SubStr(line, 1, 1) == "#") {
                continue
            }
            parts := StrSplit(line, "=")
            ret[parts[1]] := parts[2]
        }
        return ret
    }
}