; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; #.Logger
class Logger
{
    #Include <#Logger/Logger/Channel>

    static channels := {}

    addChannel(slug, logPath, logFilename)
    {
        this.channels[slug] := new #.Logger.Channel(logPath, logFilename)
    }

    getChannel(slug)
    {
        return this.channels[slug]
    }
}
