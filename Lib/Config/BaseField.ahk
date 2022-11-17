; Config.Field
class BaseField
{
    type := ""
    default := ""
    label := ""
    slug := ""
    section := ""
    options := []
    value := ""
    oldValue := ""

    __New(type, label, options := "")
    {
        if (this.options != "") {
            this.options := options
        }
        this.type := type
        this.label := label
        this.slug := String.toCamelCase(label)
        if (options.HasKey("slug")) {
            this.slug := options["slug"]
        }
        if (options.HasKey("default")) {
            this.default := options["default"]
        }
    }

    addTo(guiId, options := "")
    {
        global
        local slug := this.slug
        Gui %guiId%:Add, Edit, v%slug% %options%, % choicesList
    }
}