; === Script Information =======================================================
; Name .........: Controllers.Migrations.Base
; Description ..: A base controller class for the version migration process
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/22/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Base.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/22/2023)
; * Added This Banner
;
; Revision 2 (03/09/2023)
; * Simplify and generalize to bind any actions, if a method matches the action
; * Partially implement default actions (next, prev, finish, cancel)
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Controllers.Migrations.Base
class Base extends Controllers.Base
{
    model := ""
    view := ""

    __New(defaultValues := "")
    {
        this.model := new Models.Installation(defaultValues)
        this.view := new Views.Installer(this.model, "Test Installer")
        this.view.show()
        this.view.buildPage()
        this._bindControls()
    }

    _bindControls()
    {
        for actionName, action in this.view.actions {
            if this.hasKey(actionName) {
                this.bind(action, actionName)
            }
        }
    }

    @browse()
    {
        throw new @.ProgrammerException(A_ThisFunc, "Not yet implemented")
    }

    @next()
    {
        this.view.buildNextPage()
        this._bindControls()
    }

    @prev()
    {
        this.view.buildPrevPage()
        this._bindControls()
    }

    @finish()
    {
        ; TODO - Make the finish button disabled until we are on the last page
        this.view.destroy()
    }

    @cancel()
    {
        this.view.destroy()
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