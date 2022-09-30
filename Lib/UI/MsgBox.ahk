; UI.MsgBox
class MsgBox extends UI.Base
{
    output := {}
    static minWidth := 240

    __New(prompt, title := "", guiOptions := "-SysMenu +AlwaysOnTop")
    {
        this.promptMsg := prompt
        if (this.title == "") 
        {
            return base.__New(prompt, guiOptions)
        }
        else
        {
            return base.__New(prompt, guiOptions)
        }
    }

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

    YesNo()
    {
        Global

        Gui, MsgBoxLabel:New, % this.guiOptions, % this.title
        if (this.fontSettings != "")
        {
            Gui, MsgBoxLabel:Font, % this.fontSettings["options"], % this.fontSettings["fontName"]
        }
        Gui, MsgBoxLabel:Add, Text, % "r1", % this.promptMsg
        Gui, MsgBoxLabel:Add, Button, % "hwndYesButton w60 xm+10 Default", Yes
        Gui, MsgBoxLabel:Add, Button, % "hwndNoButton w60 yp x+100", No

        this.bind(YesButton, "YesEvent")
        this.bind(NoButton, "NoEvent")
            
        Gui, MsgBoxLabel:Show

        WinWaitClose, % title
        return % MsgBox.output
    }
}