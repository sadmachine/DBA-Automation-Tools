; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; UI.NumberDialog
class NumberDialog extends UI.BaseDialog
{
    define()
    {
        if (!this.data.hasKey("min") || !this.data.hasKey("max")) {
            throw new @.ProgrammerException(A_ThisFunc, "Either 'min' or 'max' is not defined")
        }
        options := "Range" this.data["min"] "-" this.data["max"]
        this.addControl("Edit")
        this.addControl("UpDown", options, 0)
    }
}