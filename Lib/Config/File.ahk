; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Config.File
class File
{
    group := ""
    sections := {}
    slug := ""
    loaded := false
    hasLock := false

    path[key] {
        get {
            if (key == "global") {
                return Config.globalPath(this.group.slug "\" this.slug ".ini")
            } else if (key == "local") {
                return Config.localpath(this.group.slug "\" this.slug ".ini")
            }
            throw Exception("InvalidKeyException", "Config.File.path[]", "'" key "' is not a valid path key.")
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
        for sectionSlug, section in this.sections {
            section.file := this
            section.initialize(force)
        }
    }

    add(section)
    {
        this.sections[section.slug] := section
        return this
    }

    get(identifier)
    {
        t := this._parseIdentifier(identifier)
        return this.sections[t["section"]].get(t["field"])
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
            throw Exception("ExistingLockException", "Config.File.lock()", "Cannot relock a file thats already locked.")
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
            throw Exception("MissingLockException", "Config.File.unlock()", "Cannot unlock a file if you do not own the lock.")
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
        token["section"] := parts[1]
        token["field"] := parts[2]
        return token
    }
}