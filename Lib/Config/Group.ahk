class Group
{
    scope := ""
    fields := {}
    sections := {}
    sectionList := []
    fieldList := []
    slug := ""

    path[key] {
        get {
            if (key == "global") {
                return Config.globalConfigLocation "\" this.slug ".ini"
            } else if (key == "local") {
                return Config.localConfigLocation "\" this.slug ".ini"
            }
            throw Exception("InvalidKeyException", "Config.Group.path[]", "'" key "' is not a valid path key.")
        }
        set {
            return value
        }
    }

    __New(slug := -1)
    {
        this.slug := slug
        if (slug == -1) {
            className := this.__Class
            removedGroup := RegExReplace(className, "Group$", "")
            this.slug := String.toLower(SubStr(removedGroup, 1, 1)) . SubStr(removedGroup, 2)
        }
        this.define()
    }

    initialize()
    {
        local dialog, result
        for n, field in this.fields {
            field.group := this
            try {
                field.initialize()
            } catch e {
                if (e.message != "RequiredFieldException") {
                    throw e
                }
                if (Config.promptForMissingValues) {
                    MsgBox % "The config field '" field.label "' is required, but missing a value. Please supply a value to continue."
                    dialog := UI.DialogFactory.fromConfigField(field)
                    result := dialog.prompt()
                    if (result.canceled) {
                        throw e
                    }
                    field.value := result.value
                    field.store(true)
                    MsgBox % "Check value exists"
                }
            }
        }
    }

    add(section, field)
    {
        field.section := section
        if (this.sections[section] == "") {
            this.sections[section] := []
        }
        this.sections[section].push(field)
        this.fields[field.slug] := field
        this.fieldList.push(field)
        this.sectionList.push(section)
        return field
    }

    get(fieldSlug)
    {
        this.fields[fieldSlug].get()
    }

    load()
    {
        for slug, field in this.fields {
            field.load()
        }
        return this
    }

    store()
    {
        for slug, field in this.fields {
            field.store()
        }
    }

    setDefaults()
    {
        for slug, field in this.fields {
            field.resetDefault()
        }
    }

    exists()
    {
        for n, field in this.fields {
            if (!field.exists()) {
                return false
            }
        }
        return true
    }

    ; --- "Private"  methods ---------------------------------------------------

    _destroyFiles()
    {
        for n, field in this.fields {
            if (field.exists()) {
                FileDelete, % field.path
            }
        }
    }
}