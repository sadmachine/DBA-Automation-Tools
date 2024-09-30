; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; #.Logger
class Logger
{
    #Include <#Logger/Logger/Channel>

    static channels := {}

    addChannel(slug, logPath, logFilename, logLifeTime := "")
    {
        this.channels[slug] := new #.Logger.Channel(logPath, logFilename, logLifeTime)
    }

    getChannel(slug)
    {
        return this.channels[slug]
    }
}
