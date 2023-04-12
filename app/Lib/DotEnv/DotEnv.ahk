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
; * Improved value parsing (true/false, strings), _parseValue() method added
;
; === TO-DOs ===================================================================
; TODO - Make more robust and validate keys/values
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Lib.DotEnv
class DotEnv
{
    filepath := ""

    __New(filepath)
    {
        if (!FileExist(filepath)) {
            throw new Core.ProgrammerException(A_ThisFunc, "DotEnv Filepath did not exist", {filepath: filepath})
        }
        this.filepath := filepath
    }

    toObject()
    {
        ret := {}
        Loop Read, this.filepath
        {
            line := Trim(A_LoopReadLine)

            if (SubStr(line, 1, 1) == "#") {
                continue
            }
            parts := StrSplit(line, "=")
            ret[parts[1]] := this._parseValue(parts[2])
        }
        return ret
    }

    _parseValue(value)
    {
        firstChar := SubStr(value, 1, 1)
        lastChar := SubStr(value, -1, 1)
        if (firstChar == '"' && lastChar == '"') {
            value := Trim(value, '"')
            value := StrReplace(value, '"', '```"')
        }
        if (InStr("true false", value, false)) {
            value := StrLower(value)
            value := (value == "true" ? true : false)
        }
        return value
    }
}