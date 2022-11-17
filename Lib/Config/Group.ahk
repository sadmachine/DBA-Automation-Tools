class Group
{
    fields := {}
    sections := {}
    sectionList := []
    fieldList := []
    slug := ""

    __New(slug := -1)
    {
        this.slug := slug
        if (slug == -1) {
            className := this.__Class
            removedGroup := RegExReplace(className, "Group$", "")
            this.slug := String.toLower(SubStr(removedGroup, 1, 1)) . SubStr(removedGroup, 2)
            MsgBox % this.slug
        }
        this.define()
    }

    add(section, field)
    {
        field.section := section
        if (this.sections[section] = "") {
            this.sections[section] := []
        }
        this.sections[section].push(field)
        this.fields[field.slug] := field
        this.fieldList.push(field)
        this.sectionList.push(section)
    }
}