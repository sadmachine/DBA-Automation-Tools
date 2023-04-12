; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Config.Section
class Section
{
    slug := ""
    label := ""
    fields := {}
    fieldsByLabel := {}
    file := ""
    initialized := false

    path[key] {
        get {
            if (!InStr("global local", key)) {
                throw new Core.ProgrammerException(A_ThisFunc, "'" key "' is not a valid path key.")
            }
            return this.file.path[key]
        }
    }

    __New(label, slug := -1)
    {
        this.slug := slug
        this.label := label

        if (this.slug == -1) {
            this.slug := Str.toCamelCase(this.label)
        }
    }

    initialize(force := false)
    {
        if (this.initialized) {
            return
        }
        for fieldSlug, field in this.fields {
            field.section := this
            field.initialize(force)
            this.fieldsByLabel[field.label] := field
        }
        this.initialized := true
    }

    add(fieldObj)
    {
        this.fields[fieldObj.slug] := fieldObj
        this.fieldsByLabel[fieldObj.label] := fieldObj
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