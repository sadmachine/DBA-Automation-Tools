class #
{
    #Include <#Logger\Logger>
    #Include <#Path\Path>
    #Include <#Cmd\Cmd>

    log(channelSlug)
    {
        return #.Logger.getChannel(channelSlug)
    }
}