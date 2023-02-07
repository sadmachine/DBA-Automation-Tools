; Config.StringField
class StringField extends Config.BaseField
{
    min := ""
    max := ""

    __New(label, scope := "", attributes := "")
    {
        if (attributes.HasKey("min")) {
            this.min := attributes["min"]
        }
        if (attributes.HasKey("max")) {
            this.max := attributes["max"]
        }

        base.__New("string", label, scope, attributes)
    }
}