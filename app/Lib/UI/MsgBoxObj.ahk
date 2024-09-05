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
        if (title == "") {
            base.__New(prompt, options)
        } else {
            base.__New(title, options)
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
        this.Add("Text", "w" this.width, this.promptMsg)
    }

    _Show(options := "")
    {
        Global
        if (!this.autoSize) {
            options .= " w" this.width
        }
        this.Show(options)

        if (this.type == "OK") {
            this._CenterOkButton()
        }

        WinWaitClose, % this.title
        return % this.output
    }

    _CenterOkButton()
    {
        WinGetPos, , , guiWidth,, % "ahk_id " this.hwnd
        okButtonHwnd := this.actions["OkButton"]
        GuiControl, MoveDraw, % %okButtonHwnd%, % "x" (guiWidth-60)//2
    }

    OK(showOptions := "")
    {
        this._Setup()

        this.type := "OK"
        this.actions["OkButton"] := this.Add("Button", "w60 Default", "OK")

        this.bind(this.actions["OkButton"], "OkEvent")

        return this._Show(showOptions)
    }

    YesNo(showOptions := "")
    {
        this._Setup()

        noButtonPosFromRight := (this.width - (this.margin*2)) - 60 - 20

        YesButton := this.Add("Button", "w60 xm+10 Default", "Yes")
        NoButton := this.Add("Button", "w60 yp x" noButtonPosFromRight, "No")

        this.bind(YesButton, "YesEvent")
        this.bind(NoButton, "NoEvent")

        return this._Show(showOptions)
    }
}