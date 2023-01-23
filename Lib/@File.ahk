class @File
{

    ; --- Include any subclasses -----------------------------------------------

    getFullPath(path)
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

    parseFilename(path)
    {
        SplitPath, path, filename
        return filename
    }

    parseExtension(path)
    {
        SplitPath, path,,, extension
        return extension
    }

    parseFilenameNoExtension(path)
    {
        SplitPath, path, , , , filenameWithExtension
        return filenameWithExtension
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
}