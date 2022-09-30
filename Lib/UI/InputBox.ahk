class InputBox
{
    static output := {}
    static minWidth := 240

    Submit()
    {
        Global
        Gui, InputBoxLabel:Submit
        InputBox.output := {value: InputBoxOutput, canceled: false}
    }

    Cancel()
    {
        Global
        Gui, InputBoxLabel:Destroy
        InputBox.output := {value: "", canceled: true}
    }

    prompt(prompt, title := "", font_info := "")
    {
        Global
        if (title == "") 
        {
            title := prompt
        }

        Gui, InputBoxLabel:New, % "-Sysmenu +AlwaysOnTop", % title
        if (font_info != "")
        {
            Gui, InputBoxLabel:Font, % font_info.options, % font_info.face
        }
        Gui, InputBoxLabel:Add, Text, % "r1", % prompt
        Gui, InputBoxLabel:Add, Edit, % "r1 w" InputBox.minWidth " vInputBoxOutput"
        Gui, InputBoxLabel:Add, Button, % "hwndSubmitButton w60 xm+10 Default", OK
        Gui, InputBoxLabel:Add, Button, % "hwndCancelButton w60 yp x+100", Cancel
        bindSubmitButton := ObjBindMethod(InputBox, "Submit")
        bindCancelButton := ObjBindMethod(InputBox, "Cancel")
        GuiControl, +g, % SubmitButton, % bindSubmitButton
        GuiControl, +g, % CancelButton, % bindCancelButton
            
        Gui, InputBoxLabel:Show

        WinWaitClose, % title
        return % InputBox.output
    }
}