; Config.DropdownField
class DropdownField extends Config.BaseField
{
    choices := []
    selected := ""

    __New(label, choices, scope := "", attributes := "")
    {
        this.choices := choices
        if (attributes.HasKey("selected")) {
            this.selected := attributes["selected"]
        }
        base.__New("dropdown", label, scope, attributes)
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