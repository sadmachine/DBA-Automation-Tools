#Include "Str.ahk"
#Include "UI.ahk"
class Config
{
    #Include "Config/Scope.ahk"
    #Include "Config/Group.ahk"
    #Include "Config/File.ahk"
    #Include "Config/Section.ahk"
    #Include "Config/BaseField.ahk"
    #Include "Config/DateField.ahk"
    #Include "Config/DropdownField.ahk"
    #Include "Config/NumberField.ahk"
    #Include "Config/StringField.ahk"
    #Include "Config/PathField.ahk"

    static groups := {}
    static groupsByLabel := {}
    static loaded := {}
    static localConfigLocation := A_ScriptDir "/config"
    static globalConfigLocation := ""
    static initialized := false
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
        this.groupsByLabel[group.label] := group
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
        throw new Core.ProgrammerException(A_ThisFunc, "Not yet implemented")
        ; token := this._parseIdentifier(identifier)
        ; default := this.groups[token["group"]].fields[token["field"]].default
        ; return this.groups[token["group"]].fields[token["field"]].value := default
    }

    resetAllDefaults()
    {
        throw new Core.ProgrammerException(A_ThisFunc, "Not yet implemented")
        ; this.initialize(true)
    }

    initialize(force := false)
    {
        if (this.initialized) {
            return
        }

        this._assertConfigDirectoriesExist()

        for groupSlug, group in this.groups {
            group.initialize(force)
            this.groupsByLabel[group.label] := group
        }
        this.initialized := true
    }

    clear()
    {
        this._deletePaths()
        this._unregisterAll()
    }

    ; TODO - Generalize this better
    getFieldByLabelIdentifier(labelIdentifier)
    {
        parts := StrSplit(labelIdentifier, ".")
        if (parts.Length != 4) {
            return ""
        }
        groupLabel := parts[1]
        fileLabel := parts[2]
        sectionLabel := parts[3]
        fieldLabel := parts[4]
        return this.groupsByLabel[groupLabel].filesBylabel[fileLabel].sectionsByLabel[sectionLabel].fieldsByLabel[fieldLabel]
    }

    ; --- "Private"  methods ---------------------------------------------------

    _assertConfigDirectoriesExist()
    {
        if (FileExist(this.globalConfigLocation) != "D") {
            throw new Core.FilesystemException(A_ThisFunc, "The directory " this.globalConfigLocation " does not exist.")
        }
        if (FileExist(this.localConfigLocation) != "D") {
            throw new Core.FilesystemException(A_ThisFunc, "The directory " this.localConfigLocation " does not exist.")
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