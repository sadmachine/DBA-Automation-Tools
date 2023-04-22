; === Script Information =======================================================
; Name .........: Master UI parent class
; Description ..: Handles/houses most custom UI functionality
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/09/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: UI.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/09/2023)
; * Added This Banner
; * Update to not force certain widths on utility *Box methods
;
; Revision 2 (04/19/2023)
; * Update for ahk v2
; 
; === TO-DOs ===================================================================
; ==============================================================================
class UI
{
    ; --- Sub-Classes ----------------------------------------------------------
    #Include "UI/Base.ahk"
    #Include "UI/BaseDialog.ahk"
    #Include "UI/DateDialog.ahk"
    #Include "UI/DialogFactory.ahk"
    #Include "UI/DropdownDialog.ahk"
    #Include "UI/InputBoxObj.ahk"
    #Include "UI/MsgBoxObj.ahk"
    #Include "UI/NumberDialog.ahk"
    #Include "UI/PathDialog.ahk"
    #Include "UI/ProgressBoxObj.ahk"
    #Include "UI/Required.ahk"
    #Include "UI/Settings.ahk"
    #Include "UI/StringDialog.ahk"
    #Include "UI/TreeViewBuilder.ahk"

    ; --- Class Functions ------------------------------------------------------

    static InputBox(prompt, title := "")
    {
        ib := UI.InputBoxObj(prompt, title)
        return ib.prompt(prompt, title)
    }

    static MsgBox(prompt, title := "")
    {
        mb := UI.MsgBoxObj(prompt, title)
        mb.autoSize := true
        return mb.OK()
    }

    static YesNoBox(prompt, title := "")
    {
        mb := UI.MsgBoxObj(prompt, title)
        return mb.YesNo()
    }

    ; --- Utility methods ------------------------------------------------------

    static disableCloseButton(hwnd:="")
    {
        if (hWnd="")
        {
            hWnd:=WinExist("A")
        }
        hSysMenu:=DllCall("GetSystemMenu", "Int", hWnd, "Int", FALSE)
        nCnt:=DllCall("GetMenuItemCount", "Int", hSysMenu)
        DllCall("RemoveMenu", "Int", hSysMenu, "Uint", nCnt-1, "Uint", "0x400")
        DllCall("RemoveMenu", "Int", hSysMenu, "Uint", nCnt-2, "Uint", "0x400")
        DllCall("DrawMenuBar", "Int", hWnd)
    }

    static setParent(child_hwnd, parent_hwnd)
    {
        DllCall("SetParent", "Ptr", child_hwnd, "Ptr", parent_hwnd)
    }

    static opts(m)
    {
        option_str := ""
        for key, value in m
        {
            option_str .= key value " "
        }
        return option_str
    }
}