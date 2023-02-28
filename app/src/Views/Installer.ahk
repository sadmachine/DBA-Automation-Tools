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
        this.build()
    }

    build()
    {
        ; Gui Font, s9, Segoe UI
        this.Font := {options: "s9", fontName: "Segoe UI"}
        ; Gui Add, Text, x1 y80 w480 h2 +0x10
        this.Add("Picture", "x16 y8 w64 h64 +BackgroundTrans +AltSubmit", "..\assets\Prag Logo.ico")
        ; Gui Add, Picture, x16 y8 w64 h64 +BackgroundTrans +AltSubmit, C:\Users\austi\Documents\AutoHotKey\icons\Prag Logo.ico
        ; Gui Font
        ; Gui Font, s16
        ; Gui Add, Text, x104 y16 w306 h32, DBA AutoTools Server Installer
        ; Gui Font
        ; Gui Font, s9, Segoe UI
        ; Gui Font
        ; Gui Font, cGreen
        ; Gui Add, Text, x104 y40 w120 h23 +0x200, Version 0.9.7
        ; Gui Font
        ; Gui Font, s9, Segoe UI
        ; Gui Add, Text, x0 y320 w480 h2 +0x10
        ; Gui Add, Button, x200 y328 w59 h23, < &Prev
        ; Gui Add, Button, x264 y328 w59 h23, &Next >
        ; Gui Add, Button, x344 y328 w59 h23, &Finish
        ; Gui Add, Button, x408 y328 w59 h23, &Cancel
        ; Gui Font
        ; Gui Font, cNavy
        ; Gui Add, Text, x392 y56 w81 h23 +0x200 +0x1, Page 1 / 4
        ; Gui Font

        ; Gui Show, w480 h360, Window
        ; Return

        ; GuiSize:
        ;     If (A_EventInfo == 1) {
        ;         Return
        ;     }

        ; Return

        ; GuiEscape:
        ; GuiClose:
        ; ExitApp
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