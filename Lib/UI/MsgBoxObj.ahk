; UI.MsgBox
class MsgBoxObj extends UI.Base
{
    _output := {}

    output[] {
        get {
            return this._output
        }
        set {
            this._output := value
            return this._output
        }
    }

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
        this.output := {value: "Yes", canceled: false}
    }

    NoEvent()
    {
        Global
        Gui, MsgBoxLabel:Destroy
        this.output := {value: "No", canceled: false}
    }

    OkEvent()
    {
        Global
        Gui, MsgBoxLabel:Destroy
        this.output := {value: "OK", canceled: false}
    }

    _Setup()
    {
        Global

        Gui, MsgBoxLabel:New, % this.guiOptions, % this.title
        if (this.fontSettings != "")
        {
            Gui, MsgBoxLabel:Font, % this.fontSettings["options"], % this.fontSettings["fontName"]
        }
        Gui, MsgBoxLabel:Add, Text, % "r1", % this.promptMsg
    }

    _Show()
    {
        Global
        Gui, MsgBoxLabel:Show, % "w" this.width

        WinWaitClose, % title
        return % this.output
    }

    OK()
    {
        this._Setup()

        posCenter := (this.width/2) - 30

        Gui, MsgBoxLabel:Add, Button, % "hwndOKButton w60 xm+" posCenter " Default", OK

        this.bind(OkButton, "OkEvent")

        return this._Show()
    }

    YesNo()
    {
        this._Setup()

        posFromRight := this.width - 60 - 10

        Gui, MsgBoxLabel:Add, Button, % "hwndYesButton w60 xm+10 Default", Yes
        Gui, MsgBoxLabel:Add, Button, % "hwndNoButton w60 yp x+" posFromRight, No

        this.bind(YesButton, "YesEvent")
        this.bind(NoButton, "NoEvent")

        return this._Show()
    }
}