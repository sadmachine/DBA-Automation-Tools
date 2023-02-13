; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; #.Logger
class Logger
{
    static logPath := ""

    setLocation(path)
    {
        this.logPath := #.Path.normalize(path)
        this._assertLogPathExists()
    }

    log(level, where, message, data := "")
    {
        this._assertLogPathExists()
        FormatTime, dateAndTime,, % "yyyy-MM-dd hh:mm:ss"
        StringUpper, level, level
        FileAppend
            , % dateAndTime " [" level "] [" (!where ? "<global>" : where) "] : " message "`n"
            , % #.Path.concat(this.logPath, "application.log")
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
}