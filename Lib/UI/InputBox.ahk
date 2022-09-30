#Include <UI>

class InputBox extends UI.Base
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

    Submit()
    {
        Global
        Gui, InputBoxLabel:Submit
        this.output := {value: InputBoxOutput, canceled: false}
    }

    Cancel()
    {
        Global
        Gui, InputBoxLabel:Destroy
        this.output := {value: "", canceled: true}
    }

    prompt()
    {
        Global
        Gui, InputBoxLabel:New, % this.guiOptions, % this.title
        if (this.fontSettings != "")
        {
            Gui, InputBoxLabel:Font, % this.fontSettings["options"], % this.fontSettings["fontName"]
        }
        Gui, InputBoxLabel:Add, Text, % "r1", % this.promptMsg
        Gui, InputBoxLabel:Add, Edit, % "r1 w" this.minWidth " vInputBoxOutput"
        Gui, InputBoxLabel:Add, Button, % "hwndSubmitButton w60 xm+10 Default", OK
        Gui, InputBoxLabel:Add, Button, % "hwndCancelButton w60 yp x+100", Cancel

        this.bind(SubmitButton, "Submit")
        this.bind(CancelButton, "Cancel")
            
        Gui, InputBoxLabel:Show

        WinWaitClose, % this.title
        return % this.output
    }
}