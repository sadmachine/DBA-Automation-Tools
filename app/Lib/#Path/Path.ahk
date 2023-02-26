; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; #.Path
class Path
{
    ; --- Include any subclasses -----------------------------------------------

    makeAbsolute(path)
    {
        global
        cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
        VarSetCapacity(buf, cc*(A_IsUnicode?2:1))
        DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
        return buf
    }

    parseDirectory(path)
    {
        SplitPath, path,, dir
        return dir
    }

    parseFilename(path, extension := true)
    {
        if (extension) {
            SplitPath, path, filename
            return filename
        }
        SplitPath, path, , , , filenameWithExtension
        return filenameWithExtension
    }

    parseExtension(path)
    {
        SplitPath, path,,, extension
        return extension
    }

    parseDrive(path)
    {
        SplitPath, path, , , , , drive
        return drive
    }

    isLocked(path) {
        fileStatus := FileExist(path)
        if (InStr("D", fileStatus) || fileStatus == "") {
            throw new @.FilesystemException(A_ThisFunc, "'" path "' does not exist or is a directory")
        }

        lockPath := path ".lock"
        return (FileExist(lockPath) != "")
    }

    createLock(path, waitPeriod := 200)
    {
        fileStatus := FileExist(path)
        if (InStr("D", fileStatus) || fileStatus == "") {
            throw new @.FilesystemException(A_ThisFunc, "'" path "' does not exist or is a directory")
        }

        lockPath := path ".lock"
        if (FileExist(lockPath)) {
            if (waitPeriod == -1) {
                return false
            }
            while (FileExist(lockPath)) {
                Sleep % waitPeriod
            }
        }
        FileAppend,, % lockPath
        return true
    }

    freeLock(path)
    {
        fileStatus := FileExist(path)
        if (InStr("D", fileStatus) || fileStatus == "") {
            throw new @.FilesystemException(A_ThisFunc, "'" path "' does not exist or is a directory")
        }

        lockPath := path ".lock"
        if (!FileExist(lockPath)) {
            return false
        }

        FileDelete, % lockPath
        return true
    }

    isType(path, pathType)
    {
        local exists
        exists := FileExist(path)
        return InStr(exists, pathType)
    }

    concat(path1, path2)
    {
        return RTrim(path1, "/\") "\" LTrim(path2, "/\")
    }

    normalize(path)
    {
        path := this.makeAbsolute(path)
        ; Standardize on backslashes for paths
        path := StrReplace(path, "/", "\")

        ; Directories should end in a backslash (easier to identify as a directory, not a file without an extension)
        if (this.isType(path, "D")) {
            path := RTrim(path, "\") "\"
        }

        return path
    }

    parentOf(path)
    {
        path := this.normalize(path)
        return this.normalize(RegExReplace(path,"[^\\]+\\?$"))
    }

    inUse(path)
    {
        path := this.normalize(path)
        return FileExist(path) && !FileOpen(path, "rw")
    }
}