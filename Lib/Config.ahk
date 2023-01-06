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
    static UNDEFINED := "__UNDEFINED__"

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
            this.initialize()
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
        this.initialize(true)
    }

    getGroupPath(groupSlug)
    {
        return this.baseConfigLocation "/" groupSlug ".ini"
    }

    initialize(force := false)
    {
        this._assertConfigDirectoriesExist()

        for slug, group in this.groups {
            if (force || !group.exists()) {
                group.initialize()
            }
        }
    }

    ; --- "Private"  methods ---------------------------------------------------

    _assertConfigDirectoriesExist()
    {
        if (FileExist(this.globalConfigLocation) != "D") {
            throw Exception("InvalidDirectoryException", "Config._assertConfigDirectoriesExist()", "The directory " this.globalConfigLocation " does not exist.")
        }
        if (FileExist(this.localConfigLocation) != "D") {
            throw Exception("InvalidDirectoryException", "Config._assertConfigDirectoriesExist()", "The directory " this.localConfigLocation " does not exist.")
        }
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
                group._destroyFiles()
            }
        }
    }
}
