; === Script Information =======================================================
; Name .........: Installer View
; Description ..: The GUI interface used for installation
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Installer.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; TODO - Implement
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Views.Installer
class Installer extends UI.Base
{
    __New()
    {
        base.__New("DBA AutoTools Installer")
        this.build()
    }

    build()
    {
        this.Add("Text", "w460", "Installation Location")
        this.Add("Edit", "w400", installationPath)
        this.Add("Button", "w60 Default", )

        base.build()
    }

}