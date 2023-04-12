; Config.StringField
class StringField extends Config.BaseField
{
    min := ""
    max := ""

    __New(label, scope := "", options := "")
    {
        if (options.Has("min")) {
            this.min := options["min"]
        }
        if (options.Has("max")) {
            this.max := options["max"]
        }

        super.__New("string", label, scope, options)
    }
}