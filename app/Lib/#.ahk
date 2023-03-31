; === Script Information =======================================================
; Name .........: The Library parent class
; Description ..: Should be the top-level class for all standard library classes
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/16/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: #.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/16/2023)
; * Added This Banner
;
; Revision 2 (03/21/2023)
; * Added Queue class library
;
; Revision 3 (03/31/2023)
; * Add dotenv class
;
; === TO-DOs ===================================================================
; ==============================================================================
class #
{
    #Include <#Cmd\Cmd>
    #Include <#DotEnv\DotEnv>
    #Include <#IniFile\IniFile>
    #Include <#Logger\Logger>
    #Include <#Path\Path>
    #Include <#Queue\Queue>

    log(channelSlug)
    {
        return #.Logger.getChannel(channelSlug)
    }
}