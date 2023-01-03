; Config.NumberField
class NumberField extends Config.BaseField
{
    min := ""
    max := ""
    step := ""

    __New(label, scope := "", options := "")
    {
        base.__New("number", label, scope, options)
        if (options.HasKey("min")) {
            this.min := options["min"]
        }
        if (options.HasKey("max")) {
            this.max := options["max"]
        }
        if (options.HasKey("step")) {
            this.step := options["step"]
        }
    }
}