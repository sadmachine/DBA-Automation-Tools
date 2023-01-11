; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; UI.DialogFactory
class DialogFactory
{
    fromConfigField(configField)
    {
        fieldType := configField.type
        switch fieldType {
        case "date":
            return new UI.DateDialog(configField.label)
        case "dropdown":
            data := {choices: configField.choices, selected: configField.selected}
            return new UI.DropdownDialog(configField.label, data)
        case "file":
            EnvGet userProfile, % "USERPROFILE"
            data := {startingLocation: userProfile}
            return new UI.FileDialog(configField.label, data)
        case "number":
            return new UI.NumberDialog(configField.label)
        case "string":
            return new UI.StringDialog(configField.label)
        }
    }
}