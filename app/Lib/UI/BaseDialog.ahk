; === Script Information =======================================================
; Name .........: Base Dialog
; Description ..: Base Dialog for all other dialogs to inherit from
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/09/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: BaseDialog.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/09/2023)
; * Added This Banner
; * Update to auto set control text to data.value, if it exists + no text given
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; UI.BaseDialog
class BaseDialog extends UI.Base
{
    data := ""
    resultVar := ""
    controls := []
    resultVarUsed := false

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
        if (!this.resultVarUsed) {
            resultVarOptionString := "v" this.resultVar
            if (RegExMatch(options, "v[a-zA-Z0-9_]+")) {
                options := RegexReplace(options, "v[a-zA-Z0-9_]+", resultVarOptionString)
            } else {
                options .= " " resultVarOptionString
            }
        }

        this.resultVarUsed := true

        ; If text was not passed in, and our data has a "value" key, use that for text
        if (text == "" && this.data.hasKey("value")) {
            text := this.data.value
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