; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; UI.BaseDialog
class BaseDialog extends UI.Base
{
    data := ""
    resultVar := ""
    controls := []

    __New(title, data := "")
    {
        this.data := data
        Random, randomNum
        this.resultVar := StrReplace(this.__Class, ".", "") randomNum
        this.autoSize := true
        options := "-SysMenu +AlwaysOnTop"

        base.__New(title, options)

        this.define()
    }

    addControl(controlType, options := "", text := "")
    {
        resultVarOptionString := "v" this.resultVar
        if (RegExMatch(options, "v[a-zA-Z0-9_]+")) {
            options := RegexReplace(options, "v[a-zA-Z0-9_]+", resultVarOptionString)
        } else {
            options .= resultVarOptionString
        }
        this.controls.push({controlType: controlType, options: options, text: text})
    }

    prompt(promptMessage := "")
    {
        Global
        this.ApplyFont()

        if (promptMessage != "") {
            this.Add("Text", "w" this.width - this.margin * 4, promptMessage)
        }

        for n, control in this.controls {
            this.Add(control["controlType"], control["options"], control["text"])
        }

        SaveButton := this.Add("Button", "xm Default", "Save")
        CancelButton := this.Add("Button", "x+10", "Cancel")
        this.bind(SaveButton, "SubmitEvent")
        this.bind(CancelButton, "CancelEvent")
        this.Show("xCenter yCenter")
        WinWaitClose, % this.title
        return this.output
    }

    SubmitEvent()
    {
        Global
        this.Submit()
        resultVar := this.resultVar
        resultValue := %resultVar%
        this.output := {value: resultValue, canceled: false}
    }

    CancelEvent()
    {
        Global
        this.Destroy()
        this.output := {value: "", canceled: true}
    }

    getOutput() {
        return this.output
    }
}