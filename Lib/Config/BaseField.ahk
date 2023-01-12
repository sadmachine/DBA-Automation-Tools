; Config.Field
class BaseField
{
    type := ""
    default := ""
    required := false
    label := ""
    slug := ""
    section := ""
    options := []
    value := ""
    oldValue := ""
    group := ""

    path[] {
        get {
            if (this.scope == Config.Scope.GLOBAL) {
                return this.group.path["global"]
            } else if (this.scope == Config.Scope.LOCAL) {
                return this.group.path["local"]
            }
            throw Exception("InvalidScopeException", "Config.BaseField.path[]", "this.scope = " this.scope)
        }
    }

    __New(type, label, scope := "", options := "")
    {
        if (this.options != "") {
            this.options := options
        }

        this.scope := Config.Scope.GLOBAL
        if (scope != "") {
            this.scope := scope
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
        if (options.HasKey("required")) {
            this.required := options["required"]
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

    store(force := false)
    {
        if (this.hasChanged() || force)
        {
            IniWrite, % this.value, % this.path, % this.section, % this.slug
        }
    }

    resetDefault()
    {
        IniWrite, % this.default, % this.path, % this.section, % this.slug
    }

    initialize()
    {
        local file := ""
        if (!this.exists()) {
            file := FileOpen(this.path, "w")
            if (!IsObject(file)) {
                throw Exception("CouldNotCreateFileException", "Config.BaseField.initialize()", "path = " this.path)
            }
            file.Close()
        }
        IniRead, iniValue, % this.path, % this.section, % this.slug, % Config.UNDEFINED
        if (iniValue == Config.UNDEFINED) {
            if (this.required) {
                throw Exception("RequiredFieldException", "Config.BaseField.initialize()", "path = " this.path "`nsection = " this.section "`nfield = " this.slug)
            }
            IniWrite, % this.default, % this.path, % this.section, % this.slug
        }
    }

    setOption(option, value)
    {
        this[option] := value
        return this
    }

    getOption(option)
    {
        return this[option]
    }

    exists()
    {
        return FileExist(this.path)
    }

    hasChanged()
    {
        return this.value != this.oldValue
    }
}