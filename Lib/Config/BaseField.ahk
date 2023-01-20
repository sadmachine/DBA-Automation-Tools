; Config.Field
class BaseField
{
    type := ""
    default := ""
    required := ""
    label := ""
    slug := ""
    options := []
    value := ""
    oldValue := ""
    section := ""

    static defaultRequirementValue := false

    path[] {
        get {
            if (this.scope == Config.Scope.GLOBAL) {
                return this.section.path["global"]
            } else if (this.scope == Config.Scope.LOCAL) {
                return this.section.path["local"]
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

        this.required := Config.BaseField.defaultRequirementValue

        this.type := type
        this.label := label
        this.slug := String.toCamelCase(this.label)
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

    __Call(methodName, args*)
    {
        if (SubStr(methodName, 1, 3) == "set" && !this.hasKey(methodName) & args.length() == 1) {
            option := String.toLower(SubStr(methodName, 4))
            value := args[1]
            return this.setOption(option, value)
        }
    }

    __Get(key)
    {
        if (this.hasKey(key)) {
            return this[key]
        } else if (this.options.hasKey(key)) {
            return this.options[key]
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
        IniRead, iniValue, % this.path, % this.section.slug, % this.slug
        this.value := iniValue
        this.oldValue := iniValue
    }

    store(force := false)
    {
        if (this.hasChanged() || force)
        {
            IniWrite, % this.value, % this.path, % this.section.slug, % this.slug
        }
    }

    resetDefault()
    {
        IniWrite, % this.default, % this.path, % this.section.slug, % this.slug
    }

    initialize(force := false)
    {
        local fileObj := ""
        if (!FileExist(this.path)) {
            fileObj := FileOpen(this.path, "w")
            if (!IsObject(fileObj)) {
                throw Exception("CouldNotCreateFileException", "Config.BaseField.initialize()", "path = " this.path)
            }
            fileObj.Close()
        }

        if (this._valueIsUndefined()) {
            if (this.required && this.default == "") {
                throw Exception("RequiredFieldException", "Config.BaseField.initialize()", "path = " this.path "`nsection = " this.section.slug "`nfield = " this.slug)
            }
            IniWrite, % this.default, % this.path, % this.section.slug, % this.slug
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

    get()
    {
        return this.value
    }

    set(value)
    {
        return this.value := value
    }

    exists()
    {
        return FileExist(this.path)
    }

    hasChanged()
    {
        return this.value != this.oldValue
    }

    ; --- "Private"  methods ---------------------------------------------------

    _valueIsUndefined()
    {
        IniRead, iniValue, % this.path, % this.section.slug, % this.slug, % Config.UNDEFINED
        return (iniValue == Config.UNDEFINED)
    }
}