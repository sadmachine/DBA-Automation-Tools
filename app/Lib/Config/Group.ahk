; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Config.Group
class Group
{
    files := {}
    filesByLabel := {}
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
            throw new @.ProgrammerException(A_ThisFunc, "'" key "' is not a valid path key.")
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
            this.slug := String.toLower(SubStr(modifiedClassName, 1, 1)) . SubStr(modifiedClassName, 2)
        } else {
            this.slug := String.toCamelCase(this.label)
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
                FileCreateDir, % this.path["global"]
                FileCreateDir, % this.path["local"]
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
        throw new @.ProgrammerException(A_ThisFunc, "Not yet implemented")
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
            FileRemoveDir, % this.path["global"], 1
        }
        if (localPathExists) {
            FileRemoveDir, % this.path["local"], 1
        }
    }

    _parseIdentifier(identifier)
    {
        parts := StrSplit(identifier, ".")
        token := {}
        token["file"] := parts[1]
        token["section"] := parts[2]
        token["field"] := parts[3]
    }
}
