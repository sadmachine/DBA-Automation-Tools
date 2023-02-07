; Config.NumberField
class NumberField extends Config.BaseField
{
    min := ""
    max := ""

    __New(label, scope := "", attributes := "")
    {
        base.__New("number", label, scope, attributes)
        if (attributes.HasKey("min")) {
            this.min := attributes["min"]
        } else {
            this.min := -2147483648
        }
        if (attributes.HasKey("max")) {
            this.max := attributes["max"]
        } else {
            this.max := 2147483647
        }
    }
}