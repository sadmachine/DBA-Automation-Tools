; === Script Information =======================================================
; Name .........: Lib.Logger
; Description ..: Parent logger class for adding and retrieving log channels
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/19/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Logger.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/19/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Lib.Logger
class Logger
{
    #Include "Logger/Channel.ahk"

    static channels := Map()

    static addChannel(slug, logPath, logFilename)
    {
        this.channels[slug] := Lib.Logger.Channel(logPath, logFilename)
    }

    static getChannel(slug)
    {
        return this.channels[slug]
    }
}
