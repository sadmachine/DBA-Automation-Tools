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
        this.Add("Text", "r1 xm", this.promptMsg)
        this.Add("Edit", "r1 xm w" this.width " vInputBoxOutput")
        SubmitButton := this.Add("Button", "w60 xm Default", "OK")
        CancelButton := this.Add("Button", "w60 yp x+10", "Cancel")

        this.bind(SubmitButton, "SubmitEvent")
        this.bind(CancelButton, "CancelEvent")

        this.Show("w" this.width + (this.margin*2))

        GuiControlGet, p, Pos, % %CancelButton%
        positionFromRight := this.width + this.margin - pW
        GuiControl, Move, % %CancelButton%, % "x" positionFromRight


        WinWaitClose, % this.title
        return % this.output
    }
}