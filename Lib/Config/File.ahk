; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Config.File
class File
{
    group := ""
    sections := {}
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
            throw new @.ProgrammerException(A_ThisFunc, "'" key "' is not a valid path key.")
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
            this.slug := String.toCamelCase(this.label)
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
        }
        this.initialized := true
    }

    add(section)
    {
        this.sections[section.slug] := section
        return this
    }

    get(identifier)
    {
        t := this._parseIdentifier(identifier)
        if (t["section"] == "") {
            throw new @.ProgrammerException(A_ThisFunc, "You must supply a section handle.")
        }
        if (!this.sections.hasKey(t["section"])) {
            throw new @.ProgrammerException(A_ThisFunc, "The section handle supplied '" t["section"] "' is invalid.")
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
            throw new @.FilesystemException(A_ThisFunc, "Cannot relock a file thats already locked.")
        }
        if (scope == "" || scope == Config.Scope.GLOBAL) {
            if (FileExist(this.path["global"])) {
                @File.createLock(this.path["global"])
            }
        }
        if (scope == "" || scope == Config.Scope.LOCAL) {
            if (FileExist(this.path["local"])) {
                @File.createLock(this.path["local"])
            }
        }
        this.hasLock := true
    }

    unlock(scope := "")
    {
        if (!this.hasLock) {
            throw new @.FilesystemException(A_ThisFunc, "Cannot unlock a file if you do not own the lock.")
        }

        if (scope == "" || scope == Config.Scope.GLOBAL) {
            if (FileExist(this.path["global"])) {
                @File.freeLock(this.path["global"])
            }
        }
        if (scope == "" || scope == Config.Scope.LOCAL) {
            if (FileExist(this.path["local"])) {
                @File.freeLock(this.path["local"])
            }
        }
        this.hasLock := false
    }

    awaitLock(fieldPath)
    {
        while (@File.isLocked(fieldPath) && !this.hasLock) {
            Sleep 200
        }
    }

    ; --- "Private"  methods ---------------------------------------------------

    _destroyFiles()
    {
        for sectionSlug, section in this.sections {
            for fieldSlug, field in section {
                if (field.exists()) {
                    FileDelete, % field.path
                }
            }
        }
    }

    _parseIdentifier(identifier)
    {
        parts := StrSplit(identifier, ".")
        token := {}
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