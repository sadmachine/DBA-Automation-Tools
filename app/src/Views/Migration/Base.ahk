; === Script Information =======================================================
; Name .........: Views.Migration.Base
; Description ..: The GUI interface used for version migrations
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Base.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; Revision 2 (03/09/2023)
; * Get the base gui setup and test out page functionality
; * Convert to Views.Installers.Base structure for extensibility
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Views.Migration.Base
class Base extends UI.Base
{
    actions := {}
    fields := {}
    model := ""
    pages := []
    currentPageIndex := 1

    __New(model, title, options := "")
    {
        base.__New(title, options)
        this.model := model
        this.build()
    }

    build()
    {
        ; Gui Font, s9, Segoe UI
        this.Font := {options: "s9", fontName: "Segoe UI"}
        ; Gui Add, Text, x1 y80 w480 h2 +0x10
        this.Add("Text", "x1 y80 w480 h2 +0x10")
        ; Gui Add, Picture, x16 y8 w64 h64 +BackgroundTrans +AltSubmit, C:\Users\austi\Documents\AutoHotKey\icons\Prag Logo.ico
        this.Add("Picture", "x16 y8 w64 h64 +BackgroundTrans +AltSubmit", "..\assets\Prag Logo.ico")
        ; Gui Font
        ; Gui Font, s16
        this.Font["options"] := "s16"
        ; Gui Add, Text, x104 y16 w306 h32, DBA AutoTools Server Installer
        this.Add("Text", "x104 y16 w306 h32", this.title)
        ; Gui Font
        ; Gui Font, s9, Segoe UI
        this.Font["options"] := "s9"
        ; Gui Font
        ; Gui Font, cGreen
        this.ResetFont()
        this.Font["options"] := "cGreen"
        ; Gui Add, Text, x104 y40 w120 h23 +0x200, Version 0.9.7
        this.Add("Text", "x104 y40 w120 h23 +0x200", "Version 0.9.7")
        ; Gui Font
        ; Gui Font, s9, Segoe UI
        this.ResetFont()
        this.Font := {options: "s9", fontName: "Segoe UI"}
        ; Gui Add, Text, x0 y320 w480 h2 +0x10
        this.Add("Text", "x0 y320 w480 h2 +0x10")
        ; Gui Add, Button, x200 y328 w59 h23, < &Prev
        this.actions["@prev"] := this.Add("Button", "x200 y328 w59 h23", "< &Prev")

        ; Gui Add, Button, x264 y328 w59 h23, &Next >
        this.actions["@next"] := this.Add("Button", "x264 y328 w59 h23", "&Next >")
        nextButtonEvent := ObjBindMethod(this, "@next")
        GuiControl, +g, % %nextButton%, % nextButtonEvent
        ; Gui Add, Button, x344 y328 w59 h23, &Finish
        this.actions["@finish"] := this.Add("Button", "x344 y328 w59 h23", "&Finish")
        ; Gui Add, Button, x408 y328 w59 h23, &Cancel
        this.actions["@cancel"] := this.Add("Button", "x408 y328 w59 h23", "&Cancel")
        ; Gui Font
        ; Gui Font, cNavy
        this.ResetFont()
        this.Font["options"] := "cNavy"
        ; Gui Add, Text, x392 y56 w81 h23 +0x200 +0x1, Page 1 / 4
        this.fields["pageCount"] := this.Add("Text", "x392 y56 w81 h23 +0x200 +0x1", "Page x / y")
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
        base.build()
    }

    registerPage(index, page)
    {
        this.pages.InsertAt(index, page)
        this.updatePageCount()
    }

    buildPage(pageIndex := "")
    {
        if (!this.built) {
            this.build()
        }
        if (pageIndex == "") {
            pageIndex := this.currentPageIndex
        }
        if (pageIndex < 1) {
            pageIndex := 1
        } else if (pageIndex > this.pages.Count()) {
            pageIndex := this.pages.Count()
        }

        this.DestroyChild(this.currentPageIndex)
        this.currentPageIndex := pageIndex
        this.pages[pageIndex].call(pageIndex)
        this._updatePageCount()
    }

    buildNextPage()
    {
        this.buildPage(this.currentPageIndex + 1)
    }

    buildPrevPage()
    {
        this.buildPage(this.currentPageIndex - 1)
    }

    show()
    {
        base.Show("w480 h360")
    }

    updateModel(model)
    {
        this.model := model
    }

    _updatePageCount()
    {
        pageCountStr := "Page " this.currentPageIndex " / " this.pages.count()
        GuiControl, Text, % this.fields["pageCount"], % pageCountStr
    }
}