; === Script Information =======================================================
; Name .........: Logger.Channel
; Description ..: Represents a log channel
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/11/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Channel.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/11/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Lib.Logger.Channel
class Channel
{
    logPath := ""
    logFilename := ""

    __New(path, filename)
    {
        this.logPath := Lib.Path.normalize(path)
        this.logFilename := filename
        this._assertLogPathExists()
    }

    log(level, where, message, data := "")
    {
        this._assertLogPathExists()
        dateAndTime := FormatTime(, "yyyy-MM-dd hh:mm:ss")
        level := StrUpper(level)
        if (data != "") {
            data := this._prepareData(data)
        }
        FileAppend(dateAndTime " [" level "] [" (!where ? "<global>" : where) "] " message "`n" data, Lib.Path.normalize(Lib.Path.concat(this.logPath, this.logFilename)))
    }

    info(where, message, data := "")
    {
        this.log("info", where, message, data)
    }

    warning(where, message, data := "")
    {
        this.log("warn", where, message, data)
    }

    error(where, message, data := "")
    {
        this.log("!err", where, message, data)
    }

    _assertLogPathExists()
    {
        if (!Lib.Path.isType(this.logPath, "D")) {
            this.logPath := ""
            throw new Core.ProgrammerException(A_ThisFunc, "Log Location must be a directory, non-directory specified: `n" path)
        }
    }

    _prepareData(data, level := 0)
    {
        if (!IsObject(data)) {
            if (Core.typeof(data) == "String") {
                return '"' data '",`n'
            }
            return data ",`n"
        }

        indentStep := "` ` ` ` "
        indentMore := "| " indentStep
        indent := "| "
        Loop level {
            indent .= indentStep
            indentMore .= indentStep
        }

        dataStr := ""

        if (level == 0) {
            dataStr .= "| context = "
        }
        dataStr .= "{`n"
        for index, value in data {
            dataStr .= indentMore index ": " this._prepareData(value, level+1)
        }
        dataStr .= indent "}"
        if (level != 0) {
            dataStr .= ","
        }
        dataStr .= "`n"
        return dataStr
    }
}