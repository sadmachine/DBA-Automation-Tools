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
    pages := []
    currentPage := 1

    __New(model, title := "", options := "")
    {
        base.__New(title, options)
        this.model := model
        this.registerPage(1, ObjBindMethod(this, "SelectInstallationPath"))
    }

    registerPage(index, page)
    {
        this.pages.InsertAt(index, page)
    }

    buildPage(pageIndex)
    {
        if (!this.built) {
            this.build()
        }
        if (pageIndex < 1) {
            pageIndex := 1
        } else if (pageIndex > this.pages.Count()) {
            pageIndex := this.pages.Count()
        }

        this.pages[pageIndex].call()

    }

    buildNextPage()
    {
        currentPage += 1
        this.buildPage(currentPage)
    }

    buildPrevPage()
    {
        currentPage -=1
        this.buildPage(currentPage)
    }

    show()
    {
        base.Show("w640 h480")
    }

    updateModel(model)
    {
        this.model := model
    }

    SelectInstallationPath()
    {
        this.Add("Text", "w460 +multiline", "You are installating the Server version of DBA AutoTools. Make sure to install this on a central location that all clients will have access to over the network. Its recommended to install it in the DBA Manufacturing directory in a subfolder, as all DBA Clients need access to that location anyways.")
        this.Add("Text", "w460", "Installation Location")
        this.fields["installationPath"] := this.Add("Edit", "w400", this.model.defaultInstallationPath)
        this.actions["browse"] := this.Add("Button", "w60", "Browse")
        this.actions["prev"] := this.Add("Button", "w60")
    }
}