; === Script Information =======================================================
; Name .........: File
; Description ..: Handles Config files
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/19/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: File.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/19/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Config.File
class File
{
    group := ""
    sections := Map()
    sectionsByLabel := Map()
    slug := ""
    loaded := false
    hasLock := false
    initialized := false

    path[key] {
        get {
            if (key == "global") {
                return Config.globalPath(this.group.slug "\" this.slug ".ini")
            } else if (key == "local") {
                return Config.localpath(this.group.slug "\" this.slug ".ini")
            }
            throw Core.ProgrammerException(A_ThisFunc, "'" key "' is not a valid path key.")
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
            this.slug := Str.toCamelCase(this.label)
        }
    }

    initialize(force := false)
    {
        if (this.initialized) {
            return
        }
        for sectionSlug, section in this.sections {
            section.file := this
            section.initialize(force)
            this.sectionsByLabel[section.label] := section
        }
        this.initialized := true
    }

    add(section)
    {
        this.sections[section.slug] := section
        this.sectionsByLabel[section.label] := section
        return this
    }

    get(identifier)
    {
        t := this._parseIdentifier(identifier)
        if (t["section"] == "") {
            throw Core.ProgrammerException(A_ThisFunc, "You must supply a section handle.")
        }
        if (!this.sections.Has(t["section"])) {
            throw Core.ProgrammerException(A_ThisFunc, "The section handle supplied '" t["section"] "' is invalid.")
        }
        if (t["field"] == "") {
            return this.sections[t["section"]]
        } else {
            return this.sections[t["section"]].get(t["field"])
        }
    }

    set(identifier, value)
    {
        t := this._parseIdentifier(identifier)
        return this.sections[t["section"]].set(t["field"], value)
    }

    load()
    {
        for sectionSlug, section in this.sections {
            for fieldSlug, field in section.fields {
                this.awaitLock(field.path)
                field.load()
            }
        }
        this.loaded := true
        return this
    }

    store()
    {
        for sectionSlug, section in this.sections {
            for fieldSlug, field in section.fields {
                this.awaitLock(field.path)
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

    lock(scope := "")
    {
        if (this.hasLock) {
            throw Core.FilesystemException(A_ThisFunc, "Cannot relock a file thats already locked.")
        }
        if (scope == "" || scope == Config.Scope.GLOBAL) {
            if (FileExist(this.path["global"])) {
                Lib.Path.createLock(this.path["global"])
            }
        }
        if (scope == "" || scope == Config.Scope.LOCAL) {
            if (FileExist(this.path["local"])) {
                Lib.Path.createLock(this.path["local"])
            }
        }
        this.hasLock := true
    }

    unlock(scope := "")
    {
        if (!this.hasLock) {
            throw Core.FilesystemException(A_ThisFunc, "Cannot unlock a file if you do not own the lock.")
        }

        if (scope == "" || scope == Config.Scope.GLOBAL) {
            if (FileExist(this.path["global"])) {
                Lib.Path.freeLock(this.path["global"])
            }
        }
        if (scope == "" || scope == Config.Scope.LOCAL) {
            if (FileExist(this.path["local"])) {
                Lib.Path.freeLock(this.path["local"])
            }
        }
        this.hasLock := false
    }

    awaitLock(fieldPath)
    {
        while (Lib.Path.isLocked(fieldPath) && !this.hasLock) {
            Sleep(200)
        }
    }

    ; --- "Private"  methods ---------------------------------------------------

    _destroyFiles()
    {
        for sectionSlug, section in this.sections {
            for fieldSlug, field in section {
                if (field.exists()) {
                    FileDelete(field.path)
                }
            }
        }
    }

    _parseIdentifier(identifier)
    {
        parts := StrSplit(identifier, ".")
        token := Map()
        token["section"] := ""
        token["field"] := ""
        if (parts.Count() >= 1) {
            token["section"] := parts[1]
        }
        if (parts.Count() >= 2) {
            token["field"] := parts[2]
        }
        return token
    }
}