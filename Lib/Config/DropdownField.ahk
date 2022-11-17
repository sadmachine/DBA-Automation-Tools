; Config.DropdownField
class DropdownField extends Config.BaseField
{
    choices := []
    selected := ""

    __New(label, choices, options := "")
    {
        this.choices := choices
        base.__New("dropdown", label, options)
        if (options.HasKey("selected")) {
            this.selected := options["selected"]
        }
    }

    addTo(guiId, options := "")
    {
        global
        local slug := this.slug
        local choicesList := this._getChoicesList()
        local selectedIndex := this.selectedIndex
        Gui %guiId%:Add, DDL, v%slug% Choose%selectedIndex% %options%, % choicesList
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