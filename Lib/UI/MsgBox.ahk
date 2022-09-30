class MsgBox
{
    static output := {}
    static minWidth := 240

    YesEvent()
    {
        Global
        Gui, MsgBoxLabel:Submit
        MsgBox.output := {value: "Yes", canceled: false}
    }

    NoEvent()
    {
        Global
        Gui, MsgBoxLabel:Destroy
        MsgBox.output := {value: "No", canceled: false}
    }

    YesNo(prompt, title := "", font_info := "")
    {
        Global
        if (title == "") 
        {
            title := prompt
        }

        Gui, MsgBoxLabel:New, % "-Sysmenu +AlwaysOnTop", % title
        if (font_info != "")
        {
            Gui, MsgBoxLabel:Font, % font_info.options, % font_info.face
        }
        Gui, MsgBoxLabel:Add, Text, % "r1", % prompt
        Gui, MsgBoxLabel:Add, Button, % "hwndYesButton w60 xm+10 Default", Yes
        Gui, MsgBoxLabel:Add, Button, % "hwndNoButton w60 yp x+100", No
        bindYesButton := ObjBindMethod(MsgBox, "YesEvent")
        bindNoButton := ObjBindMethod(MsgBox, "NoEvent")
        GuiControl, +g, % YesButton, % bindYesButton
        GuiControl, +g, % NoButton, % bindNoButton
            
        Gui, MsgBoxLabel:Show

        WinWaitClose, % title
        return % MsgBox.output
    }
}