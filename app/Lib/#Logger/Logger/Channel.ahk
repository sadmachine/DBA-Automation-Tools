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
; Revision 2 (04/23/2023)
; * If log file is in use, create unique file and write to that instead
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; #.Logger.Channel
class Channel
{
    logPath := ""
    logFilename := ""

    __New(path, filename)
    {
        this.logPath := #.Path.normalize(path)
        this.logFilename := filename
        this.location := #.Path.concat(this.logPath, this.logFilename)
        this._assertLogPathExists()
    }

    log(level, where, message, data := "")
    {
        this._assertLogPathExists()
        FormatTime, dateAndTime,, % "yyyy-MM-dd hh:mm:ss"
        StringUpper, level, level
        if (data != "") {
            data := this._prepareData(data)
        }
        filePath := this.location
        if (#.path.inUse(filePath)) {
            filePath := this._createUnique(filePath)
        }

        FileAppend
            , % dateAndTime " [" level "] [" A_UserName "] [" (!where ? "<global>" : where) "] " message "`n" data
            , % filePath
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

    _createUnique(path)
    {
        filePathBase := this.logPath
        filenameBase := #.path.parseFilename(path, false)
        index := -1
        loop {
            index += 1
            filename := filenameBase "." index ".ini"
            filePath := #.Path.concat(filePathBase, filename)
        } until (!#.path.inUse(filePath))

        return filePath
    }

    _assertLogPathExists()
    {
        if (!#.Path.isType(this.logPath, "D")) {
            this.logPath := ""
            throw new @.ProgrammerException(A_ThisFunc, "Log Location must be a directory, non-directory specified: `n" path)
        }
    }

    _prepareData(data, level := 0)
    {
        if (!IsObject(data)) {
            if (@.typeof(data) == "String") {
                return """" data """,`n"
            }
            return data ",`n"
        }

        indentStep := "` ` ` ` "
        indentMore := "| " indentStep
        indent := "| "
        Loop % level {
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