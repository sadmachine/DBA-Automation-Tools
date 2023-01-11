class UI
{
    ; --- Sub-Classes ----------------------------------------------------------
    #Include <UI/Base>
    #Include <UI/InputBoxObj>
    #Include <UI/MsgBoxObj>
    #Include <UI/ProgressBoxObj>
    #Include <UI/Settings>
    #Include <UI/Required>
    #Include <UI/DialogFactory>
    #Include <UI/BaseDialog>
    #Include <UI/DateDialog>
    #Include <UI/DropdownDialog>
    #Include <UI/FileDialog>
    #Include <UI/NumberDialog>
    #Include <UI/StringDialog>

    ; --- Class Functions ------------------------------------------------------

    InputBox(prompt, title := "")
    {
        ib := new UI.InputBoxObj(prompt, title)
        ib.width := 280
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
        mb.width := 280
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