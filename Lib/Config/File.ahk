; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Config.File
class File
{
    group := ""
    sections := {}
    slug := ""
    loaded := false

    path[key] {
        get {
            if (key == "global") {
                return Config.globalPath(this.group.slug "\" this.slug ".ini")
            } else if (key == "local") {
                return Config.localpath(this.group.slug "\" this.slug ".ini")
            }
            throw Exception("InvalidKeyException", "Config.File.path[]", "'" key "' is not a valid path key.")
        }
        set {
            return value
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
        for sectionSlug, section in this.sections {
            section.file := this
            section.initialize(force)
        }
    }

    add(section)
    {
        this.sections[section.slug] := section
        return this
    }

    get(identifier)
    {
        t := this._parseIdentifier(identifier)
        this.sections[t["section"]][t["field"]].get()
    }

    load()
    {
        for sectionSlug, section in this.sections {
            for fieldSlug, field in section.fields {
                field.load()
            }
        }
        this.loaded := true
        return this
    }

    store()
    {
        for sectionSlug, section in this.sections {
            for fieldSlug, field in section {
                field.store()
            }
        }
    }

    setDefaults()
    {
        for sectionSlug, section in this.sections {
            for fieldSlug, field in section {
                field.resetDefault()
            }
        }
    }

    exists()
    {
        for sectionSlug, section in this.sections {
            if (!section.exists()) {
                return false
            }
        }
        return true
    }

    ; --- "Private"  methods ---------------------------------------------------

    _destroyFiles()
    {
        for sectionSlug, section in this.sections {
            for fieldSlug, field in section {
                if (field.exists()) {
                    FileDelete, % field.path
                }
            }
        }
    }

    _parseIdentifier(identifier)
    {
        parts := StrSplit(identifier, ".")
        token := {}
        token["section"] := parts[1]
        token["field"] := parts[2]
    }
}