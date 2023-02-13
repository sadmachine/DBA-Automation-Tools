; Config.NumberField
class NumberField extends Config.BaseField
{
    min := ""
    max := ""

    __New(label, scope := "", options := "")
    {
        base.__New("number", label, scope, options)
        if (options.HasKey("min")) {
            this.min := options["min"]
        } else {
            this.min := -2147483648
        }
        if (options.HasKey("max")) {
            this.max := options["max"]
        } else {
            this.max := 2147483647
        }
    }
}