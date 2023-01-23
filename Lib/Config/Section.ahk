; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Config.Section
class Section
{
    slug := ""
    label := ""
    fields := {}
    file := ""

    path[key] {
        get {
            if (!InStr("global local", key)) {
                throw new @.ProgrammerException(A_ThisFunc, "'" key "' is not a valid path key.")
            }
            return this.file.path[key]
        }
    }

    __New(label, slug := -1)
    {
        this.slug := slug
        this.label := label

        if (this.slug == -1) {
            this.slug := String.toCamelCase(this.label)
        }
    }

    initialize(force := false)
    {
        for fieldSlug, field in this.fields {
            field.section := this
            try {
                field.initialize(force)
            } catch e {
                MsgBox % @.typeOf(e)
                if (e.what != "RequiredFieldException") {
                    throw e
                }
                if (Config.promptForMissingValues) {
                    fullFieldIdentifier := this.file.group.label "." this.file.label "." this.label "." field.label
                    UI.MsgBox("The config field '" fullFieldIdentifier "' is required, but missing a value. Please supply a value to continue.", "Required Field Missing")
                    dialog := UI.DialogFactory.fromConfigField(field)
                    result := dialog.prompt()
                    if (result.canceled) {
                        throw e
                    }
                    field.value := result.value
                    field.store(true)
                }
            }
        }
    }

    add(fieldObj)
    {
        this.fields[fieldObj.slug] := fieldObj
        return this
    }

    get(identifier)
    {
        return this.fields[identifier].get()
    }

    set(identifier, value)
    {
        return this.fields[identifier].value := value
    }

    exists()
    {
        for fieldSlug, field in this.fields {
            if (!field.exists()) {
                return false
            }
        }
        return true
    }
}