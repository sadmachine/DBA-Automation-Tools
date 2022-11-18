#Include <String>
class Config
{
    #include <Config/Group>
    #include <Config/BaseField>
    #include <Config/DateField>
    #include <Config/NumberField>
    #include <Config/StringField>
    #include <Config/FileField>

    static groups := {}
    static groupList := []
    static baseConfigLocation := A_ScriptDir "/config"

    setBaseConfigLocation(baseConfigLocation)
    {
        this.baseConfigLocation := baseConfigLocation
    }

    register(group)
    {
        group.path := this.getGroupPath(group.slug)
        this.groups[group.slug] := group
        this.groupList.push(group)
    }

    load()
    {
        this._initialize()
        for slug, group in this.groups {
            group.load()
        }
    }

    store()
    {
        for slug, group in this.groups {
            group.store()
        }
    }

    get(identifier)
    {
        token := this._parseIdentifier(identifier)
        return this.groups[token["group"]].fields[token["field"]].value
    }

    set(identifier, value)
    {
        token := this._parseIdentifier(identifier)
        return this.groups[token["group"]].fields[token["field"]].value := value
    }

    setDefault(identifier)
    {
        token := this._parseIdentifier(identifier)
        default := this.groups[token["group"]].fields[token["field"]].default
        return this.groups[token["group"]].fields[token["field"]].value := default
    }

    resetAllDefaults()
    {
        this._initialize(true)
    }

    getGroupPath(groupSlug)
    {
        return this.baseConfigLocation "/" groupSlug ".ini"
    }

    ; --- "Private"  methods ---------------------------------------------------

    _initialize(force := false)
    {
        this._assertConfigDirectoryExists()

        for slug, group in this.groups {
            if (force || !group.exists()) {
                group.setDefaults()
            }
        }
    }

    _assertConfigDirectoryExists()
    {
        if (FileExist(this.baseConfigLocation) != "D") {
            throw Exception("Directory Not Found", -1, "The directory " this.baseConfigLocation " does not exist.")
        }
        return this.baseConfigLocation
    }

    _parseIdentifier(identifier)
    {
        parts := StrSplit(identifier, ".")
        token := {}
        token["group"] := parts[1]
        token["section"] := parts[2]
        token["field"] := parts[3]
        return token
    }

    _destroyGroupFiles()
    {
        for slug, group in this.groups {
            if (group.exists()) {
                FileDelete, % group.path
            }
        }
    }
}
