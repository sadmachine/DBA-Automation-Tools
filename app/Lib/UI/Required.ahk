; UI.Required
class Required
{
    static strict := false

    InputBox(prompt, title := "", throwOnFailure := true)
    {
        result := UI.InputBox(prompt, title)
        if (result.canceled || (this.strict && Trim(result.value) == ""))
        {
            if (throwOnFailure) {
                throw new @.RequiredFieldException(A_ThisFunc, prompt, "You must supply an input for '" prompt "' to continue.")
            } else {
                MsgBox % "You must supply an input to continue. Exiting..."
                ExitApp
            }
        }
        return result.value
    }

    YesNoBox(prompt, title := "", throwOnFailure := true)
    {
        result := UI.YesNoBox(prompt, title)
        if (result.canceled)
        {
            if (throwOnFailure) {
                throw new @.RequiredFieldException(A_ThisFunc, prompt, "You must respond yes or no to '" prompt "' to continue.")
            } else {
                MsgBox % "You must respond yes or no to continue. Exiting..."
                ExitApp
            }
        }
        return result.value
    }
}