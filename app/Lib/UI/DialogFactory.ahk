; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
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
            return new UI.DropdownDialog(configField.label, configField)
        case "path":
            return new UI.PathDialog(configField.label, configField)
        case "number":
            return new UI.NumberDialog(configField.label, configField)
        case "string":
            return new UI.StringDialog(configField.label)
        }
    }
}