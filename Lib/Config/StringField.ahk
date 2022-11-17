; Config.StringField
class StringField extends Config.BaseField
{
    min := ""
    max := ""

    __New(label, options := "")
    {
        base.__New("string", label, options)

        if (options.HasKey("min")) {
            this.min := options["min"]
        }
        if (options.HasKey("max")) {
            this.max := options["max"]
        }
    }
}