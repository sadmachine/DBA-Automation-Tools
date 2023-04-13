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
; Revision 5 (04/12/2023)
; * Fix issues with `inUse()` where it would lock files indefinitely on certain
; * ... systems
; * Update how OnError and OnExit methods are registered
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; #.Path
class Path
{
    ; --- Include any subclasses -----------------------------------------------

    #Include <#Path/Path/Temp>

    static lockPaths := {}
    static registered := false

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
        if (!#.Path.registered) {
            cleanupMethod := ObjBindMethod(this, "_cleanup")
            OnExit(cleanupMethod, -1)
            OnError(cleanupMethod, -1)
            #.Path.registered := true
        }
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
        #.Path.lockPaths[lockPath] := lockPath
        FileSetAttrib, +H, % lockPath
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
        #.Path.lockPaths.Delete(lockPath)
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
        directory := this.parseDirectory(path)
        filename := this.parseFilename(path)
        temporaryFile := this.concat(directory, "~$" filename)
        if (FileExist(temporaryFile)) {
            return true
        }
        FileGetsize, size, % path
        if (Errorlevel) {
            return true
        } else {
            return false
        }
    }

    _cleanup()
    {
        for index, path in #.Path.lockPaths {
            FileDelete, % path
        }
        return 0
    }
}