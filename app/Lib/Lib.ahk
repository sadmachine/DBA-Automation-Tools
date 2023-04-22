; === Script Information =======================================================
; Name .........: The Library parent class
; Description ..: Should be the top-level class for all standard library classes
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/16/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Lib.ahk
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
; Revision 4 (04/19/2023)
; * Update for ahk v2
; 
; === TO-DOs ===================================================================
; ==============================================================================
class Lib
{
    #Include "Cmd\Cmd.ahk"
    #Include "DotEnv\DotEnv.ahk"
    #Include "IniFile\IniFile.ahk"
    #Include "Logger\Logger.ahk"
    #Include "Path\Path.ahk"
    #Include "Queue\Queue.ahk"
    #Include "DriveMap\DriveMap.ahk"

    static log(channelSlug)
    {
        return Lib.Logger.getChannel(channelSlug)
    }
}