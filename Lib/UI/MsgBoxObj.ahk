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

    __New(prompt, title := "", options := "-SysMenu +AlwaysOnTop")
    {
        this.promptMsg := prompt
        if (this.title == "")
        {
            return base.__New(prompt, options)
        }
        else
        {
            return base.__New(prompt, options)
        }
    }

    YesEvent()
    {
        Global
        this.Submit()
        this.output := {value: "Yes", canceled: false}
    }

    NoEvent()
    {
        Global
        this.Destroy()
        this.output := {value: "No", canceled: false}
    }

    OkEvent()
    {
        Global
        this.Destroy()
        this.output := {value: "OK", canceled: false}
    }

    _Setup()
    {
        Global

        this.ApplyFont()
        this.Add("Text", "r2", this.promptMsg)
    }

    _Show()
    {
        Global
        this.Show("w" this.width)

        WinWaitClose, % this.title
        return % this.output
    }

    OK()
    {
        this._Setup()

        posCenter := (this.width/2) - 15 - (this.margin*2)

        OkButton := this.Add("Button", "w60 x" posCenter " Default", "OK")

        this.bind(OkButton, "OkEvent")

        return this._Show()
    }

    YesNo()
    {
        this._Setup()

        posFromRight := (this.width - (this.margin*2)) - 60 - 20

        YesButton := this.Add("Button", "w60 xm+10 Default", "Yes")
        NoButton := this.Add("Button", "w60 yp x" posFromRight, "No")

        this.bind(YesButton, "YesEvent")
        this.bind(NoButton, "NoEvent")

        return this._Show()
    }
}