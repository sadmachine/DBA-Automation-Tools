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
    actions := {}
    fields := {}
    model := ""
    currentScreen := 1

    __New(model)
    {
        base.__New("DBA AutoTools Server Installer")
        this.model := model
        this.build()
    }

    build(screenIndex)
    {
        this.Add("Text", "w460", "Installation Location")
        this.fields["installationPath"] := this.Add("Edit", "w400", this.model.defaultInstallationPath)
        this.actions["browse"] := this.Add("Button", "w60 Default", "Browse")
        base.build()
    }

    buildNext()
    {
        currentScreen += 1
        this.build(currentScreen)
    }

    buildPrev()
    {
        currentScreen -=1
        this.build(currentScreen)
    }

    show()
    {
        base.Show("w640 h480")
    }

    updateModel(model)
    {

    }
}