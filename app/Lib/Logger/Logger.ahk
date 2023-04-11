; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Lib.Logger
class Logger
{
    #Include "Logger/Channel.ahk"

    static channels := {}

    addChannel(slug, logPath, logFilename)
    {
        this.channels[slug] := new Lib.Logger.Channel(logPath, logFilename)
    }

    getChannel(slug)
    {
        return this.channels[slug]
    }
}
