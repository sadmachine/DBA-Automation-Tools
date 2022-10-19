; UI.InputBox
class InputBoxObj extends UI.Base
{
    output := {}
    __instance := true

    __New(prompt, title := "", guiOptions := "-SysMenu +AlwaysOnTop")
    {
        this.promptMsg := prompt
        if (this.title == "")
        {
            return base.__New(prompt, guiOptions)
        }
        else
        {
            return base.__New(title, guiOptions)
        }
    }

    SubmitEvent()
    {
        Global
        Gui, InputBoxLabel:Submit
        this.output := {value: InputBoxOutput, canceled: false}
    }

    CancelEvent()
    {
        Global
        Gui, InputBoxLabel:Destroy
        this.output := {value: "", canceled: true}
    }

    prompt()
    {
        Global
        Gui, InputBoxLabel:New, % this.guiOptions, % this.title
        if (this.Font != "")
        {
            Gui, InputBoxLabel:Font, % this.Font["options"], % this.Font["fontName"]
        }
        Gui, InputBoxLabel:Add, Text, % "r1", % this.promptMsg
        Gui, InputBoxLabel:Add, Edit, % "r1 w" this.width - (this.margin*2) " vInputBoxOutput"
        posFromRight := this.width - 60 - 10 - this.margin
        Gui, InputBoxLabel:Add, Button, % "hwndSubmitButton w60 xm+10 Default", OK
        Gui, InputBoxLabel:Add, Button, % "hwndCancelButton w60 yp x" posFromRight, Cancel

        this.bind(SubmitButton, "SubmitEvent")
        this.bind(CancelButton, "CancelEvent")

        Gui, InputBoxLabel:Show, % "w" this.width

        WinWaitClose, % this.title
        return % this.output
    }
}