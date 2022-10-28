; UI.InputBox
class InputBoxObj extends UI.Base
{
    output := {}
    __instance := true

    __New(prompt, title := "", options := "-SysMenu +AlwaysOnTop")
    {
        this.promptMsg := prompt
        if (this.title == "")
        {
            return base.__New(prompt, options)
        }
        else
        {
            return base.__New(title, options)
        }
    }

    SubmitEvent()
    {
        Global
        this.Submit()
        this.output := {value: InputBoxOutput, canceled: false}
    }

    CancelEvent()
    {
        Global
        this.Destroy()
        this.output := {value: "", canceled: true}
    }

    prompt()
    {
        Global
        this.ApplyFont()
        this.Add("Text", "r1", this.promptMsg)
        this.Add("Edit", "r1 w" this.width - (this.margin*2) - 10 " vInputBoxOutput")
        posFromRight := this.width - 60 - 10 - this.margin
        SubmitButton := this.Add("Button", "w60 xm+10 Default", "OK")
        CancelButton := this.Add("Button", "w60 yp x" posFromRight, "Cancel")

        this.bind(SubmitButton, "SubmitEvent")
        this.bind(CancelButton, "CancelEvent")

        this.Show("w" this.width + (this.margin*2))

        WinWaitClose, % this.title
        return % this.output
    }
}