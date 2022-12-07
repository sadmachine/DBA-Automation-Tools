class UI
{
    #Include <UI/Base>
    #Include <UI/InputBoxObj>
    #Include <UI/MsgBoxObj>
    #Include <UI/ProgressBoxObj>

    ; --- Class Functions --------------------------------------------------------

    InputBox(prompt, title := "")
    {
        ib := new UI.InputBoxObj(prompt, title)
        ib.width := 280
        return ib.prompt(prompt, title)
    }

    RequiredInput(input_name, throwOnFailure := true)
    {
        result := UI.InputBox("Enter " input_name)
        if (result.canceled)
        {
            if (throwOnFailure) {
                throw Exception("InvalidInputException", -1, "You must supply a(n) " input_name " to continue.")
            } else {
                MsgBox % "You must supply a " field_name " to continue. Exiting..."
                ExitApp
            }
        }
        return result.value
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

    ; --- Utility methods --------------------------------------------------------

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