; Config.DropdownField
class DropdownField extends Config.BaseField
{
    choices := []
    selected := ""

    __New(label, choices, scope := "", options := "")
    {
        this.choices := choices
        if (options.HasKey("selected")) {
            this.selected := options["selected"]
        }
        base.__New("dropdown", label, scope, options)
    }

    _getChoicesList()
    {
        choicesList := ""
        this.selectedIndex := 1
        for index, choice in this.choices {
            choicesList .= choice . "|"
            if (choice == this.selected) {
                this.selectedIndex := index
            }
        }
        choicesList := RTrim(choicesList, "|")
    }
}