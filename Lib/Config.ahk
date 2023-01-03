#Include <String>
class Config
{
    #Include <Config/Scope>
    #include <Config/Group>
    #include <Config/BaseField>
    #include <Config/DateField>
    #include <Config/NumberField>
    #include <Config/StringField>
    #include <Config/FileField>

    static groups := {}
    static groupList := []
    static localConfigLocation := A_ScriptDir "/config"
    static globalConfigLocation := ""

    setLocalConfigLocation(localConfigLocation)
    {
        this.localConfigLocation := localConfigLocation
    }

    setGlobalConfigLocation(globalConfigLocation)
    {
        this.globalConfigLocation := globalConfigLocation
    }

    register(group)
    {
        group.path := this.getGroupPath(group.slug)
        this.groups[group.slug] := group
        this.groupList.push(group)
    }

    load(groupSlug:="")
    {
        if (groupSlug == "") {
            this._initialize()
            for slug, group in this.groups {
                group.load()
            }
        } else {
            this.groups[groupSlug].load()
        }
    }

    store(groupSlug:="")
    {
        if (groupSlug == "") {
            for slug, group in this.groups {
                group.store()
            }
        } else {
            this.groups[groupSlug].store()
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

    resetDefault(identifier)
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
