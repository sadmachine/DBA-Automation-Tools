; === Script Information =======================================================
; Name .........: Dialog Factory
; Description ..: Converts a config field to a dialog class
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/09/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: DialogFactory.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/09/2023)
; * Added This Banner
; * Specify more descriptive title for dialogs
; * Supply configField to all dialog types, by default
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; UI.DialogFactory
class DialogFactory
{
    fromConfigField(configField)
    {
        fieldType := configField.type
        title := configField.label " (" configField.getFullIdentifier() ")"
        switch fieldType {
        case "date":
            return new UI.DateDialog(title, configField)
        case "dropdown":
            return new UI.DropdownDialog(title, configField)
        case "path":
            return new UI.PathDialog(title, configField)
        case "number":
            return new UI.NumberDialog(title, configField)
        case "string":
            return new UI.StringDialog(title, configField)
        }
    }
}