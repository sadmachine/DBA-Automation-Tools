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
; === TO-DOs ===================================================================
; ==============================================================================
class UI
{
    ; --- Sub-Classes ----------------------------------------------------------
    #Include <UI/Base>
    #Include <UI/BaseDialog>
    #Include <UI/DateDialog>
    #Include <UI/DialogFactory>
    #Include <UI/DropdownDialog>
    #Include <UI/InputBoxObj>
    #Include <UI/MsgBoxObj>
    #Include <UI/NumberDialog>
    #Include <UI/PathDialog>
    #Include <UI/ProgressBoxObj>
    #Include <UI/Required>
    #Include <UI/Settings>
    #Include <UI/StringDialog>
    #Include <UI/TreeViewBuilder>

    ; --- Class Functions ------------------------------------------------------

    InputBox(prompt, title := "")
    {
        ib := new UI.InputBoxObj(prompt, title)
        return ib.prompt(prompt, title)
    }

    MsgBox(prompt, title := "")
    {
        mb := new UI.MsgBoxObj(prompt, title)
        mb.autoSize := true
        return mb.OK()
    }

    YesNoBox(prompt, title := "")
    {
        mb := new UI.MsgBoxObj(prompt, title)
        return mb.YesNo()
    }

    ; --- Utility methods ------------------------------------------------------

    disableCloseButton(hwnd="")
    {
        if (hWnd="")
        {
            hWnd:=WinExist("A")
        }
        hSysMenu:=DllCall("GetSystemMenu","Int",hWnd,"Int",FALSE)
        nCnt:=DllCall("GetMenuItemCount","Int",hSysMenu)
        DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-1,"Uint","0x400")
        DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-2,"Uint","0x400")
        DllCall("DrawMenuBar","Int",hWnd)
    }

    setParent(child_hwnd, parent_hwnd)
    {
        DllCall("SetParent", Ptr, child_hwnd, Ptr, parent_hwnd)
    }

    opts(object)
    {
        option_str := ""
        for key, value in object
        {
            option_str .= key value " "
        }
        return option_str
    }
}