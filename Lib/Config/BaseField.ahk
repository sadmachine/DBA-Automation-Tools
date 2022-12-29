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
    path := ""

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

    load()
    {
        IniRead, iniValue, % this.path, % this.section, % this.slug
        this.value := iniValue
        this.oldValue := iniValue
    }

    store()
    {
        if (this.hasChanged())
        {
            IniWrite, % this.value, % this.path, % this.section, % this.slug
        }
    }

    resetDefault()
    {
        IniWrite, % this.default, % this.path, % this.section, % this.slug
    }

    hasChanged()
    {
        return this.value != this.oldValue
    }
}