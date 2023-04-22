; === Script Information =======================================================
; Name .........: Config
; Description ..: Parent class for all config classes
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/19/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Config.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/19/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
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

    static groups := Map()
    static groupsByLabel := Map()
    static loaded := Map()
    static localConfigLocation := A_ScriptDir "/config"
    static globalConfigLocation := ""
    static initialized := false
    static UNDEFINED := "__UNDEFINED__"

    static setLocalConfigLocation(localConfigLocation)
    {
        this.localConfigLocation := localConfigLocation
    }

    static setGlobalConfigLocation(globalConfigLocation)
    {
        this.globalConfigLocation := globalConfigLocation
    }

    static localPath(append)
    {
        return RTrim(this.localConfigLocation, "/\") "\" LTrim(append, "/\")
    }

    static globalPath(append)
    {
        return RTrim(this.globalConfigLocation, "/\") "\" LTrim(append, "/\")
    }

    static register(group)
    {
        this.groups[group.slug] := group
        this.groupsByLabel[group.label] := group
    }

    static load(identifier)
    {
        t := this._parseIdentifier(identifier)
        thisGroup := this.groups[t["group"]].load(t["file"])
        return thisGroup
    }

    static lock(identifier, scope := "")
    {
        t := this._parseIdentifier(identifier)
        return this.groups[t["group"]].files[t["file"]].lock(scope)
    }

    static unlock(identifier, scope := "")
    {
        t := this._parseIdentifier(identifier)
        return this.groups[t["group"]].files[t["file"]].unlock(scope)
    }

    static store(identifier)
    {
        t := this._parseIdentifier(identifier)
        return this.groups[t["group"]][t["group"]].store()
    }

    static get(identifier)
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
        } else if (t["section"] != "" && t["field"] != "") {
            return thisFile.get(t["section"] "." t["field"])
        } else {
            return thisFile
        }
    }

    static resetDefault(identifier)
    {
        throw Core.ProgrammerException(A_ThisFunc, "Not yet implemented")
        ; token := this._parseIdentifier(identifier)
        ; default := this.groups[token["group"]].fields[token["field"]].default
        ; return this.groups[token["group"]].fields[token["field"]].value := default
    }

    static resetAllDefaults()
    {
        throw Core.ProgrammerException(A_ThisFunc, "Not yet implemented")
        ; this.initialize(true)
    }

    static initialize(force := false)
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

    static clear()
    {
        this._deletePaths()
        this._unregisterAll()
    }

    ; TODO - Generalize this better
    static getFieldByLabelIdentifier(labelIdentifier)
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

    static _assertConfigDirectoriesExist()
    {
        if (FileExist(this.globalConfigLocation) != "D") {
            throw Core.FilesystemException(A_ThisFunc, "The directory " this.globalConfigLocation " does not exist.")
        }
        if (FileExist(this.localConfigLocation) != "D") {
            throw Core.FilesystemException(A_ThisFunc, "The directory " this.localConfigLocation " does not exist.")
        }
    }

    static _parseIdentifier(identifier)
    {
        parts := StrSplit(identifier, ".")
        token := Map()
        token["group"] := (parts.Count() >= 1 ? parts[1] : "")
        token["file"] := (parts.Count() >= 2 ? parts[2] : "")
        token["section"] := (parts.Count() >= 3 ? parts[3] : "")
        token["field"] := (parts.Count() >= 4 ? parts[4] : "")
        return token
    }

    static _deletePaths()
    {
        for groupSlug, group in this.groups {
            group._deletePaths()
        }
    }

    static _unregisterAll()
    {
        this.groups := Map()
    }
}