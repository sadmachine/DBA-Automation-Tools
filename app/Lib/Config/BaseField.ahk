; === Script Information =======================================================
; Name .........: BaseField
; Description ..: Base Config field for all others to extend
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/19/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: BaseField.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/19/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; Config.Field
class BaseField
{
    type := ""
    default := ""
    required := ""
    label := ""
    slug := ""
    options := Map()
    value := ""
    oldValue := ""
    section := ""
    initialized := false

    static defaultRequirementValue := false

    path
    {
        get {
            if (this.scope == Config.Scope.GLOBAL) {
                return this.section.path["global"]
            } else if (this.scope == Config.Scope.LOCAL) {
                return this.section.path["local"]
            }
            throw Core.ProgrammerException(A_ThisFunc, "Invalid scope, this.scope = " this.scope)
        }
    }

    __New(type, label, scope := "", options := Map())
    {
        if (options != Map()) {
            this.options := options
        }

        this.scope := Config.Scope.GLOBAL
        if (scope != "") {
            this.scope := scope
        }

        this.required := Config.BaseField.defaultRequirementValue

        this.type := type
        this.label := label
        this.slug := Str.toCamelCase(this.label)
        if (this.options.Has("slug")) {
            this.slug := options["slug"]
        }
        if (this.options.Has("default")) {
            this.default := options["default"]
        }
        if (this.options.Has("required")) {
            this.required := options["required"]
        }
    }

    __Call(methodName, args*)
    {
        if (SubStr(methodName, 1, 3) == "set" && !this.Has(methodName) && args.Length == 1) {
            option := Str.toLower(SubStr(methodName, 4))
            value := args[1]
            return this.setOption(option, value)
        }
    }

    __Get(key)
    {
        if (this.Has(key)) {
            return this[key]
        } else if (this.options.Has(key)) {
            return this.options[key]
        }
    }

    load()
    {
        iniValue := IniRead(this.path, this.section.slug, this.slug)
        this.value := iniValue
        this.oldValue := iniValue
    }

    store(force := false)
    {
        if (this.hasChanged() || force)
        {
            IniWrite(this.value, this.path, this.section.slug, this.slug)
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
                throw Core.FilesystemException(A_ThisFunc, "Could not create file, path = " this.path)
            }
            fileObj.Close()
        }

        if (this._valueIsUndefined()) {
            if (this.required && this.default == "") {
                throw Core.RequiredFieldException(A_ThisFunc, this, "path = " this.path "`nsection = " this.section.slug "`nfield = " this.slug)
            }
            IniWrite(this.default, this.path, this.section.slug, this.slug)
        }
        this.initialized := true
    }

    setOption(option, value)
    {
        this.options[option] := value
        return this
    }

    getOption(option)
    {
        return this.options[option]
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
        iniValue := IniRead(this.path, this.section.slug, this.slug, Config.UNDEFINED)
        return (iniValue == Config.UNDEFINED)
    }
}