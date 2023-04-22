﻿; === Script Information =======================================================
; Name .........: Config.Group
; Description ..: Handles config groups (directories)
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/19/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Group.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/19/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Config.Group
class Group
{
    files := Map()
    filesByLabel := Map()
    label := ""
    slug := ""
    initialized := false

    path[key] {
        get {
            if (key == "global") {
                return Config.globalPath(this.slug)
            } else if (key == "local") {
                return Config.localpath(this.slug)
            }
            throw Core.ProgrammerException(A_ThisFunc, "'" key "' is not a valid path key.")
        }
        set {
            return value
        }
    }

    __New(slug := -1)
    {
        this.slug := slug

        this.define()

        if (this.slug == -1 && this.label == "") {
            className := this.__Class
            modifiedClassName := RegExReplace(className, "Group$", "")
            this.slug := Str.toLower(SubStr(modifiedClassName, 1, 1)) . SubStr(modifiedClassName, 2)
        } else {
            this.slug := Str.toCamelCase(this.label)
        }
    }

    initialize(force := false)
    {
        local dialog, result
        if (this.initialized) {
            return
        }
        for fileSlug, file in this.files {
            if (!this._pathsExist()) {
                DirCreate(this.path["global"])
                DirCreate(this.path["local"])
            }
            file.group := this
            file.initialize(force)
            this.filesByLabel[file.label] := file
        }
        this.initialized := true
    }

    add(fileObj)
    {
        this.files[fileObj.slug] := fileObj
        this.filesByLabel[fileObj.label] := fileObj
        return this
    }

    get(identifier)
    {
        t := this._parseIdentifier(identifier)
        return this.files[t["file"]].get(t["section"] "." t["field"])
    }

    load(fileSlug)
    {
        return this.files[fileSlug].load()
    }

    store(fileSlug)
    {
        this.files[fileSlug].store()
    }

    setDefaults()
    {
        throw Core.ProgrammerException(A_ThisFunc, "Not yet implemented")
    }

    exists()
    {
        if (!this._pathsExist()) {
            return false
        }

        for fileSlug, file in this.files {
            if (!file.exists()) {
                return false
            }
        }

        return true
    }

    ; --- "Private"  methods ---------------------------------------------------

    _pathsExist()
    {
        globalPathExists := InStr(FileExist(this.path["global"]), "D")
        localPathExists := InStr(FileExist(this.path["local"]), "D")
        if (!globalPathExists || !localPathExists) {
            return false
        }

        return true
    }

    _deletePaths()
    {
        for fileSlug, file in this.files {
            if (file.exists()) {
                file._deletePaths()
            }
        }

        globalPathExists := InStr(FileExist(this.path["global"]), "D")
        localPathExists := InStr(FileExist(this.path["local"]), "D")
        if (globalPathExists) {
            DirDelete(this.path["global"], 1)
        }
        if (localPathExists) {
            DirDelete(this.path["local"], 1)
        }
    }

    _parseIdentifier(identifier)
    {
        parts := StrSplit(identifier, ".")
        token := Map()
        token["file"] := parts[1]
        token["section"] := parts[2]
        token["field"] := parts[3]
    }
}
