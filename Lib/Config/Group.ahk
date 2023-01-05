class Group
{
    scope := ""
    fields := {}
    sections := {}
    sectionList := []
    fieldList := []
    slug := ""
    _path := ""

    path[] {
        get {
            return this._path
        }
        set {
            this._path := value
            for slug, field in this.fields {
                field.path := this._path
            }
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
        for n, field in this.fields {
            field.initialize()
        }
    }

    add(section, field)
    {
        field.section := section
        field.group := this
        if (this.sections[section] = "") {
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

        this.fields[fieldSlug]
    }

    load()
    {
        for slug, field in this.fields {
            field.load()
        }
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
}