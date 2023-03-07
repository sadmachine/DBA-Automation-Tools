; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; #.Logger
class Logger
{
    static logPath := ""
    static logFilename := ""

    setLocation(path, filename)
    {
        this.logPath := #.Path.normalize(path)
        this.logFilename := filename
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
        FileAppend
            , % dateAndTime " [" level "] [" (!where ? "<global>" : where) "] " message "`n" data
            , % #.Path.normalize(#.Path.concat(this.logPath, this.logFilename))
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
