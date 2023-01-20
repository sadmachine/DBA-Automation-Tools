#Include <String>
#Include <UI>
class Config
{
    #Include <Config/Scope>
    #include <Config/Group>
    #Include <Config/File>
    #Include <Config/Section>
    #include <Config/BaseField>
    #include <Config/DateField>
    #include <Config/DropdownField>
    #include <Config/NumberField>
    #include <Config/StringField>
    #include <Config/PathField>

    static groups := {}
    static loaded := {}
    static localConfigLocation := A_ScriptDir "/config"
    static globalConfigLocation := ""
    static promptForMissingValues := true
    static UNDEFINED := "__UNDEFINED__"

    setLocalConfigLocation(localConfigLocation)
    {
        this.localConfigLocation := localConfigLocation
    }

    setGlobalConfigLocation(globalConfigLocation)
    {
        this.globalConfigLocation := globalConfigLocation
    }

    localPath(append)
    {
        return RTrim(this.localConfigLocation, "/\") "\" LTrim(append, "/\")
    }

    globalPath(append)
    {
        return RTrim(this.globalConfigLocation, "/\") "\" LTrim(append, "/\")
    }

    register(group)
    {
        this.groups[group.slug] := group
    }

    load(identifier)
    {
        t := this._parseIdentifier(identifier)
        thisGroup := this.groups[t["group"]].load(t["file"])
        return thisGroup
    }

    lock(identifier, scope := "")
    {
        t := this._parseIdentifier(identifier)
        return this.groups[t["group"]].files[t["file"]].lock(scope)
    }

    unlock(identifier, scope := "")
    {
        t := this._parseIdentifier(identifier)
        return this.groups[t["group"]].files[t["file"]].unlock(scope)
    }

    store(identifier)
    {
        t := this._parseIdentifier(identifier)
        return this.groups[t["group"]][t["group"]].store()
    }

    get(identifier)
    {
        t := this._parseIdentifier(identifier)
        thisFile := ""
        if (!this.group[t["group"]].files[t["file"]].loaded) {
            thisFile := this.load(identifier)
        } else {
            thisFile := this.groups[t["group"]].files[t["file"]]
        }
        if (t["section"] != "" && t["field"] == "") {
            return thisFile.section[t["section"]]
        } else if (t["section"] != "" & t["field"] != "") {
            return thisFile.get(t["section"] "." t["field"])
        } else {
            return thisFile
        }
    }

    resetDefault(identifier)
    {
        throw Exception("NotImplementedException", "Config.resetDefault()", "Not yet implemented")
        ; token := this._parseIdentifier(identifier)
        ; default := this.groups[token["group"]].fields[token["field"]].default
        ; return this.groups[token["group"]].fields[token["field"]].value := default
    }

    resetAllDefaults()
    {
        throw Exception("NotImplementedException", "Config.resetAllDefaults()", "Not yet implemented")
        ; this.initialize(true)
    }

    initialize(force := false)
    {
        this._assertConfigDirectoriesExist()

        for groupSlug, group in this.groups {
            group.initialize(force)
        }
    }

    clear()
    {
        this._deletePaths()
        this._unregisterAll()
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
        token["group"] := (parts.Count() >= 1 ? parts[1] : "")
        token["file"] := (parts.Count() >= 2 ? parts[2] : "")
        token["section"] := (parts.Count() >= 3 ? parts[3] : "")
        token["field"] := (parts.Count() >= 4 ? parts[4] : "")
        return token
    }

    _deletePaths()
    {
        for groupSlug, group in this.groups {
            group._deletePaths()
        }
    }

    _unregisterAll()
    {
        this.groups := {}
    }
}

@Config(identifier)
{
    Config.get(identifier)
}