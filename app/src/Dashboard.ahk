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

    initialize()
    {
        Global
        this._setupTrayMenu()
        daemon := ObjBindMethod(Dashboard, "_daemon")
        SetTimer, % daemon, 250
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
        WinWait, % DBA.Windows.Main
        WinActivate, % DBA.Windows.Main
        WinWaitActive, % DBA.Windows.Main

        ; Build the dashboard
        Gui, dashboard:Margin, 0, 0
        Gui, dashboard:Font, s12
        this._buildModuleSections()
        Gui, dashboard: +OwnDialogs +AlwaysOnTop HWNDhChild

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
        Gui, dashboard:Show, % UI.opts({"h": this.height, "w": this.width, "x": this.display_x, "y": this.display_y}), Automation Tools
        ; Need to set the parent of the gui to the "DBA NG Sub-Assy Jobs" program
        ; This makes it so our dashboard moves with the parent window, and acts like its part of the program
        UI.setParent(this.hwnd["child"], this.hwnd["parent"])

        UI.disableCloseButton(this.hwnd["child"])
    }

    destroyOnClose()
    {
        WinWaitClose, % DBA.Windows.Main
        Gui, dashboard:Destroy
        this.built := false
    }

    _setupApplicationMenu()
    {
        global

        ; Get a reference to our events
        openSettingsEvent := ObjBindMethod(this, "@openSettings")

        ; Gui Menu setup
        Menu, DashboardMenuBar, Add, &Settings, % openSettingsEvent
        Gui, dashboard:Menu, DashboardMenuBar

    }

    _setupTrayMenu()
    {
        ; Get a reference to our events
        openSettingsEvent := ObjBindMethod(this, "@openSettings")
        applicationLogEvent := ObjBindMethod(this, "@applicationLog")
        exitProgramEvent := ObjBindMethod(this, "@exitProgram")

        ; Tray Menu Setup
        Menu, Tray, NoStandard
        Menu, Tray, Add, Settings, % openSettingsEvent
        Menu, AdvancedSubMenu, Add, Application Log, % applicationLogEvent
        Menu, Tray, Add, Advanced, :AdvancedSubMenu
        Menu, Tray, Add, Exit, % exitProgramEvent
    }

    _buildModuleSections()
    {
        Global
        sections := ModuleLoader.sections
        last_section_hwnd := ""
        section_hwnds := []
        section_module_hwnds := {}
        module_hwnds := []
        last_section_hwnd := []
        for section_title, modules in sections
        {
            if (A_Index == 1)
            {
                Gui, dashboard:Add, GroupBox, % UI.opts({"hwnd": "last_section_hwnd", "Section": ""}), % section_title
            }
            else
            {
                GuiControlGet, last_section_pos, dashboard:Pos, % last_section_hwnd
                Gui, dashboard:Add, GroupBox, % UI.opts({"hwnd": "last_section_hwnd", "Section": "", "x": "s+0", "y": "s+" last_section_posH + 5}), % section_title
            }
            section_hwnds.push(last_section_hwnd)
            section_module_hwnds[last_section_hwnd] := []
            for module_title, module in modules
            {
                if (A_Index == 1)
                {
                    Gui, dashboard:Add, Button, % UI.opts({"hwnd": "module_hwnd", "x": "s+5", "y": "s+20", "Center": "", g: "LaunchModule"}), % module_title
                }
                else
                {
                    Gui, dashboard:Add, Button, % UI.opts({"hwnd": "module_hwnd", "x": "p", "y": "+5", "Center": "", g: "LaunchModule"}), % module_title
                }
                module_hwnds.push(module_hwnd)
                section_module_hwnds[last_section_hwnd].push(module_hwnd)
            }

        }

        this._resizeControls(module_hwnds, section_hwnds, section_module_hwnds)
    }

    _resizeControls(module_hwnds, section_hwnds, section_module_hwnds)
    {
        Global
        max_width := 0
        for index, hwnd in module_hwnds
        {
            GuiControlGet, btn_pos, dashboard:Pos, % hwnd
            if (btn_posW > max_width)
            {
                max_width := btn_posW
            }
        }

        for index, hwnd in module_hwnds
        {
            GuiControl, dashboard:Move, % hwnd, % UI.opts({"w": max_width})
        }

        for index, hwnd in section_hwnds
        {
            height_sum := 0
            for index, module_hwnd in section_module_hwnds[hwnd]
            {
                GuiControlGet, btn_pos, dashboard:Pos, % module_hwnd
                height_sum += btn_posH
            }
            section_height := this.section_padding_top + (this.button_interior_padding * (section_module_hwnds[hwnd].Length()-1)) + this.section_padding_bottom + height_sum
            if (A_Index == 1)
            {
                GuiControl, dashboard:Move, % hwnd, % UI.opts({"h": section_height, "w": (this.section_padding_x * 2) + max_width})
            }
            else
            {
                GuiControl, dashboard:Move, % hwnd, % UI.opts({"x": previousX, "y": previousY + previousH + 5, "h": section_height, "w": (this.section_padding_x * 2) + max_width})
            }
            GuiControlGet, previous, dashboard:Pos, % hwnd
        }
    }

    @openSettings()
    {
        Run, % #.Path.concat($["PROJECT_ROOT"], "Settings.exe")
    }

    @exitProgram()
    {
        global
        ExitApp
    }

    @applicationLog()
    {
        tempDir := new #.Path.Temp("DBA AutoTools")
        tempApplicationLogPath := tempDir.concat("application.log")
        applicationLogPath := #.Path.concat($["PROJECT_ROOT"], "modules\application.log")
        #.Cmd.copy(applicationLogPath, tempApplicationLogPath)
        Run, % "notepad.exe """ tempApplicationLogPath """"
    }
}