; === Script Information =======================================================
; Name .........: Dashboard Interface
; Description ..: The main "DBA AutoTools" dashboard
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Dashboard.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; Revision 2 (03/07/2023)
; * Update tray menu and menu actions
;
; Revision 3 (03/27/2023)
; * Use new global var syntax
;
; Revision 4 (04/09/2023)
; * Removed "auto" placement of modules/sections
; * Manually placed receiving section/module
;
; Revision 5 (04/10/2023)
; * Properly disable receiving modules if not present
;
; === TO-DOs ===================================================================
; TODO - Abstract out to a controller and a view
; TODO - Update to actually handle modules (old way is broken, only works for single module)
; ==============================================================================
class Dashboard
{
    static built := false
    static vertical_fix := 65
    static height := 200
    static width := 300
    static padding := 20
    static hwnd := []
    static display_x := 0
    static display_y := 0
    static sections := []
    static modules := []
    static section_padding_top := 20
    static section_padding_bottom := 5
    static section_padding_x := 5
    static button_interior_padding := 5
    static guiObj := {}

    initialize()
    {
        Global
        this._setupTrayMenu()
        daemon := ObjBindMethod(Dashboard, "_daemon")
        SetTimer(daemon,250)
    }

    _daemon() {
        if (!this.built) {
            this.build(true)
        } else {
            this.destroyOnClose()
        }
    }

    build(show := false)
    {
        this.display_x := 234 + this.padding
        this.display_y := 74

        ; Wait for the Main DBA window to be active
        WinWait(DBA.Windows.Main)
        WinActivate(DBA.Windows.Main)
        WinWaitActive(DBA.Windows.Main)

        ; Build the dashboard
        this.guiObj := Gui(,, this.Events)
        this.guiObj.MarginX := "0", this.guiObj.MarginY := "0"
        this.guiObj.SetFont("s12")
        this._buildReceivingSection()
        this.guiObj.Opt("+OwnDialogs +AlwaysOnTop HWNDhChild")

        ; Build/Add menus
        this._setupApplicationMenu()

        ; Get a reference to the "parent" and "child" window
        this.hwnd["parent"] := WinExist(DBA.Windows.Main)
        this.hwnd["child"] := hChild

        this.built := true

        if (show) {
            this.show()
        }
    }

    show()
    {
        Global
        this.guiObj.Title := "Automation Tools"
        this.guiObj.Show(UI.opts({"h": this.height, "w": this.width, "x": this.display_x, "y": this.display_y}))
        ; Need to set the parent of the gui to the "DBA NG Sub-Assy Jobs" program
        ; This makes it so our dashboard moves with the parent window, and acts like its part of the program
        UI.setParent(this.hwnd["child"], this.hwnd["parent"])

        UI.disableCloseButton(this.hwnd["child"])
    }

    destroyOnClose()
    {
        WinWaitClose(DBA.Windows.Main)
        this.guiObj.Destroy()
        this.built := false
    }

    _buildReceivingSection()
    {
        this.guiObj.Add("GroupBox", "Section w132 h60", "Receiving")
        options := "+Disabled"
        this._addModuleEvent(this.guiObj.Add("Button", "xs+5 ys+20 " . options, "PO Verification"))
    }

    _addModuleEvent(moduleButton)
    {
        if (ModuleLoader.has(moduleButton.Text)) {
            moduleButton.OnEvent("Click", "launchModule")
        }
    }

    _setupApplicationMenu()
    {
        global

        ; Get a reference to our events
        openSettingsEvent := ObjBindMethod(this.Events, "openSettings")

        ; Gui Menu setup
        DashboardMenuBar := Menu()
        DashboardMenuBar.Add("&Settings", openSettingsEvent)
        this.guiObj.MenuBar := DashboardMenuBar

    }

    _setupTrayMenu()
    {
        ; Get a reference to our events
        openSettingsEvent := ObjBindMethod(this.Events, "openSettings")
        applicationLogEvent := ObjBindMethod(this.Events, "applicationLog")
        exitProgramEvent := ObjBindMethod(this.Events, "exitProgram")

        ; Tray Menu Setup
        Tray:= A_TrayMenu
        Tray.Delete() ; V1toV2: not 100% replacement of NoStandard, Only if NoStandard is used at the beginning
        Tray.Add("Settings", openSettingsEvent)
        AdvancedSubMenu := Menu()
        AdvancedSubMenu.Add("Application Log", applicationLogEvent)
        Tray.Add("Advanced", AdvancedSubMenu)
        Tray.Add("Exit", exitProgramEvent)
    }

    class Events {
        openSettings()
        {
            Run(#.Path.concat($["PROJECT_ROOT"], "Settings.exe"))
        }

        exitProgram()
        {
            global
            ExitApp()
        }

        applicationLog()
        {
            tempDir := new #.Path.Temp("DBA AutoTools")
            tempApplicationLogPath := tempDir.concat("application.log")
            applicationLogPath := #.Path.concat($["PROJECT_ROOT"], "modules\application.log")
            #.Cmd.copy(applicationLogPath, tempApplicationLogPath)
            Run("notepad.exe """ tempApplicationLogPath """")
        }
    }

}
