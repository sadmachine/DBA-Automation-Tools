; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; UI.DropdownDialog
class DropdownDialog extends UI.BaseDialog
{
    build()
    {
        if (!this.data.HasKey("choices")) {
            throw Exception("MissingKeyException", "UI.DropdownDialog.define()", "this.data is missing required key 'choices'")
        }
        selected := ""
        if (this.data.HasKey("selected") && this.data["selected"] != "") {
            selected := this.data["selected"]
        }
        choices := this.data["choices"]
        choiceString := ""
        lastChoiceIsSelected := false
        for n, choice in choices {
            lastChoiceIsSelected := false
            choiceString .= choice "|"
            if (choice == selected) {
                choiceString .= "|"
                lastChoiceIsSelected := true
            }
        }
        if (!lastChoiceIsSelected) {
            choiceString := RTrim(choiceString, "|")
        }
        this.setControl("DropDownList", "", choiceString)
    }
}