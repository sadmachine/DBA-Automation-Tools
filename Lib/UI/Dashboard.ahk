class Dashboard
{

    static initialized  := false
    static vertical_fix := 65
    static height       := 200
    static width        := 300
    static padding      := 20
    static hwnd         := []
    static display_x    := 0
    static display_y    := 0
    static sections     := []
    static modules      := []
    static section_padding_top := 20
    static section_padding_bottom := 5 
    static section_padding_x := 5
    static button_interior_padding := 5

    initialize()
    {
        Global

        this.display_x := 234 + this.padding
        this.display_y := 74
        ; Wait for the "Sub-Assy Jobs" screen to be active
        WinActivate, % DBA.Windows.Main
        WinWaitActive, % DBA.Windows.Main

        ; Build the dashboard
        Gui, dashboard:Margin, 0, 0
        Gui, dashboard:Font, s12
        this._buildModuleSections()
        Gui, dashboard: +OwnDialogs +AlwaysOnTop HWNDhChild

        ; Get a reference to the "parent" and "child" window
        this.hwnd["parent"] := WinExist(DBA.Windows.Main)
        this.hwnd["child"] := hChild
    }

    show()
    {
        Global
        Gui, dashboard:Show, % UI.Utils.opts({"h": this.height, "w": this.width, "x": this.display_x, "y": this.display_y}), Automation Tools
        ; Need to set the parent of the gui to the "DBA NG Sub-Assy Jobs" program
        ; This makes it so our dashboard moves with the parent window, and acts like its part of the program
        UI.Utils.setParent(this.hwnd["child"], this.hwnd["parent"])

        UI.Utils.disableCloseButton(this.hwnd["child"])
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
                Gui, dashboard:Add, GroupBox, % UI.Utils.opts({"hwnd": "last_section_hwnd", "Section": ""}), % section_title
            }
            else 
            {
                GuiControlGet, last_section_pos, dashboard:Pos, % last_section_hwnd
                Gui, dashboard:Add, GroupBox, % UI.Utils.opts({"hwnd": "last_section_hwnd", "Section": "", "x": "s+0", "y": "s+" last_section_posH + 5}), % section_title
            }
            section_hwnds.push(last_section_hwnd)
            section_module_hwnds[last_section_hwnd] := []
            for module_title, module in modules
            {
                if (A_Index == 1)
                {
                    Gui, dashboard:Add, Button, % UI.Utils.opts({"hwnd": "module_hwnd", "x": "s+5", "y": "s+20", "Center": "", g: "LaunchModule"}), % module_title
                } 
                else
                {
                    Gui, dashboard:Add, Button, % UI.Utils.opts({"hwnd": "module_hwnd", "x": "p", "y": "+5", "Center": "", g: "LaunchModule"}), % module_title
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
            GuiControl, dashboard:Move, % hwnd, % UI.Utils.opts({"w": max_width})
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
                GuiControl, dashboard:Move, % hwnd, % UI.Utils.opts({"h": section_height, "w": (this.section_padding_x * 2) + max_width})
            }
            else
            {
                GuiControl, dashboard:Move, % hwnd, % UI.Utils.opts({"x": previousX, "y": previousY + previousH + 5, "h": section_height, "w": (this.section_padding_x * 2) + max_width})
            }
            GuiControlGet, previous, dashboard:Pos, % hwnd
        }
    }

}