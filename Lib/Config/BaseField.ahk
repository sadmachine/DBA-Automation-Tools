; Config.Field
class BaseField
{
    type := ""
    default := ""
    required := ""
    label := ""
    slug := ""
    attributes := []
    value := ""
    oldValue := ""
    section := ""
    initialized := false

    static defaultRequirementValue := false

    path[] {
        get {
            if (this.scope == Config.Scope.GLOBAL) {
                return this.section.path["global"]
            } else if (this.scope == Config.Scope.LOCAL) {
                return this.section.path["local"]
            }
            throw new @.ProgrammerException(A_ThisFunc, "Invalid scope, this.scope = " this.scope)
        }
    }

    __New(type, label, scope := "", attributes := "")
    {
        if (this.attributes != "") {
            this.attributes := attributes
        }

        this.scope := Config.Scope.GLOBAL
        if (scope != "") {
            this.scope := scope
        }

        this.required := Config.BaseField.defaultRequirementValue

        this.type := type
        this.label := label
        this.slug := String.toCamelCase(this.label)
        if (attributes.HasKey("slug")) {
            this.slug := attributes["slug"]
        }
        if (attributes.HasKey("default")) {
            this.default := attributes["default"]
        }
        if (attributes.HasKey("required")) {
            this.required := attributes["required"]
        }
    }

    __Call(methodName, args*)
    {
        if (SubStr(methodName, 1, 3) == "set" && !this.hasKey(methodName) && args.length() == 1) {
            option := String.toLower(SubStr(methodName, 4))
            value := args[1]
            return this.setOption(option, value)
        }
    }

    __Get(key)
    {
        if (this.hasKey(key)) {
            return this[key]
        } else if (this.attributes.hasKey(key)) {
            return this.attributes[key]
        }
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
        this.value := this.default
    }

    initialize(force := false)
    {
        local fileObj := ""
        if (this.initialized && force == false) {
            return
        }
        if (!FileExist(this.path)) {
            fileObj := FileOpen(this.path, "w")
            if (!IsObject(fileObj)) {
                throw new @.FilesystemException(A_ThisFunc, "Could not create file, path = " this.path)
            }
            fileObj.Close()
        }

        if (this._valueIsUndefined()) {
            if (this.required && this.default == "") {
                throw new @.RequiredFieldException(A_ThisFunc, this, "path = " this.path "`nsection = " this.section.slug "`nfield = " this.slug)
            }
            IniWrite, % this.default, % this.path, % this.section.slug, % this.slug
        }
        this.initialized := true
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

    exists()
    {
        return FileExist(this.path)
    }

    hasChanged()
    {
        return this.value != this.oldValue
    }

    getFullIdentifier()
    {
        return this.section.file.group.label "." this.section.file.label "." this.section.label "." this.label
    }

    getFullSlugIdentifier()
    {
        return this.section.file.group.slug "." this.section.file.slug "." this.section.slug "." this.slug
    }

    ; --- "Private"  methods ---------------------------------------------------

    _valueIsUndefined()
    {
        IniRead, iniValue, % this.path, % this.section.slug, % this.slug, % Config.UNDEFINED
        return (iniValue == Config.UNDEFINED)
    }
}