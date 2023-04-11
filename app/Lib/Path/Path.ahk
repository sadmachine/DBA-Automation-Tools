; === Script Information =======================================================
; Name .........: Path
; Description ..: Utility class for working with paths
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/28/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Path.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/28/2023)
; * Added This Banner
;
; Revision 2 (02/28/2023)
; * Include Temp as subclass (Path.Temp)
;
; Revision 4 (03/05/2023)
; * Add lockPaths variable, and cleanup all lockfiles on exit
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Lib.Path
class Path
{
    ; --- Include any subclasses -----------------------------------------------

    #Include "Path/Temp.ahk"

    static lockPaths := {}

    makeAbsolute(path)
    {
        global
        cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
        VarSetStrCapacity(&buf, cc*(1?2:1)) ; V1toV2: if 'buf' is NOT a UTF-16 string, use 'buf := Buffer(cc*(A_IsUnicode?2:1))'
        DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
        return buf
    }

    parseDirectory(path)
    {
        SplitPath(path, , &dir)
        return dir
    }

    parseFilename(path, extension := true)
    {
        if (extension) {
            SplitPath(path, &filename)
            return filename
        }
        SplitPath(path, , , , &filenameWithExtension)
        return filenameWithExtension
    }

    parseExtension(path)
    {
        SplitPath(path, , , &extension)
        return extension
    }

    parseDrive(path)
    {
        SplitPath(path, , , , , &drive)
        return drive
    }

    isLocked(path) {
        fileStatus := FileExist(path)
        if (InStr("D", fileStatus) || fileStatus == "") {
            throw new Core.FilesystemException(A_ThisFunc, "'" path "' does not exist or is a directory")
        }

        lockPath := path ".lock"
        return (FileExist(lockPath) != "")
    }

    createLock(path, waitPeriod := 200)
    {
        if (Lib.Path.lockPaths.Count == 0) {
            cleanupMethod := ObjBindMethod(this, "_cleanup")
            OnExit(cleanupMethod, -1)
            OnError(%cleanupMethod%, -1)
        }
        fileStatus := FileExist(path)
        if (InStr("D", fileStatus) || fileStatus == "") {
            throw new Core.FilesystemException(A_ThisFunc, "'" path "' does not exist or is a directory")
        }

        lockPath := path ".lock"
        if (FileExist(lockPath)) {
            if (waitPeriod == -1) {
                return false
            }
            while (FileExist(lockPath)) {
                Sleep(waitPeriod)
            }
        }
        FileAppend(, lockPath)
        Lib.Path.lockPaths[lockPath] := lockPath
        FileSetAttrib("+H", lockPath)
        return true
    }

    freeLock(path)
    {
        fileStatus := FileExist(path)
        if (InStr("D", fileStatus) || fileStatus == "") {
            throw new Core.FilesystemException(A_ThisFunc, "'" path "' does not exist or is a directory")
        }

        lockPath := path ".lock"
        if (!FileExist(lockPath)) {
            return false
        }

        FileDelete(lockPath)
        Lib.Path.lockPaths.Delete(lockPath)
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
        return this.normalize(RegExReplace(path, "[^\\]+\\?$"))
    }

    inUse(path)
    {
        path := this.normalize(path)
        directory := this.parseDirectory(path)
        filename := this.parseFilename(path)
        temporaryFile := this.concat(directory, "~$" filename)
        if (FileExist(temporaryFile)) {
            return true
        }
        return FileExist(path) && !FileOpen(path, "rw")
    }

    _cleanup()
    {
        for index, path in Lib.Path.lockPaths {
            FileDelete(path)
        }
        return 0
    }
}