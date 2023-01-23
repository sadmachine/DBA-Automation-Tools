; UI.Required
class Required
{
    InputBox(prompt, title := "", throwOnFailure := true)
    {
        result := UI.InputBox(prompt, title)
        if (result.canceled)
        {
            if (throwOnFailure) {
                throw new @.ValidationException(A_ThisFunc, "You must supply an input to continue.")
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
                throw new @.ValidationException(A_ThisFunc, "You must respond yes or no to continue.")
            } else {
                MsgBox % "You must respond yes or no to continue. Exiting..."
                ExitApp
            }
        }
        return result.value
    }
}