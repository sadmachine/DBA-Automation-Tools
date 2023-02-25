; === Script Information =======================================================
; Name .........: Controllers.ServerInstaller
; Description ..: A controller for the installation process
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/22/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: ServerInstaller.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/22/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Controllers.ServerInstaller
class ServerInstaller extends Controllers.Base
{
    model := ""
    view := ""

    __New(defaultInstallationPath)
    {
        this.view := new Views.ServerInstaller(defaultInstallationPath)
        this.view.build(1)
        this._bindControls()
    }

    _bindControls()
    {
        this.bind(this.view.actions["browse"], "@browse")
        this.bind(this.view.actions["next"], "@next")
        this.bind(this.view.actions["prev"], "@prev")
        this.bind(this.view.actions["finish"], "@finish")
        this.bind(this.view.actions["cancel"], "@cancel")
    }

    @browse()
    {
        throw new @.ProgrammerException(A_ThisFunc, "Not yet implemented")
    }

    @next()
    {
        throw new @.ProgrammerException(A_ThisFunc, "Not yet implemented")
    }

    @prev()
    {
        throw new @.ProgrammerException(A_ThisFunc, "Not yet implemented")
    }

    @finish()
    {
        throw new @.ProgrammerException(A_ThisFunc, "Not yet implemented")
    }

    @cancel()
    {
        throw new @.ProgrammerException(A_ThisFunc, "Not yet implemented")
    }

    install()
    {
        throw new @.ProgrammerException(A_ThisFunc, "Not yet implemented")
    }

    migrate()
    {
        throw new @.ProgrammerException(A_ThisFunc, "Not yet implemented")
    }
}