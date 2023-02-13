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
        ib.width := 320
        return ib.prompt(prompt, title)
    }

    MsgBox(prompt, title := "")
    {
        mb := new UI.MsgBoxObj(prompt, title)
        mb.width := 320
        mb.autoSize := true
        return mb.OK()
    }

    YesNoBox(prompt, title := "")
    {
        mb := new UI.MsgBoxObj(prompt, title)
        mb.width := 320
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