; === Script Information =======================================================
; Name .........: INI Queue File Driver
; Description ..: Handles reading and writing queue data to .ini files
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/23/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Ini.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/23/2023)
; * Added This Banner
;
; Revision 2 (03/24/2023)
; * Implement the createFile and readFile methods
;
; Revision 3 (03/31/2023)
; * Add constructor
; * Major bug fixes and optimizations
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; #.Queue.FileDrivers.Ini
class Ini extends #.Queue.FileDrivers.Base
{
    __New(path)
    {
        base.__New(path, ".ini")
    }

    createFile(namespace, data)
    {
        local file
        filePath := this._getUniqueFilename(namespace)
        this._createLock(namespace)
        file := new #.IniFile(filePath)
        file.writeObject(data)
        this._deleteLock(namespace)
        return filePath
    }

    readFile(filePath)
    {
        local file
        while (this._isLocked(filePath)) {
            Sleep 100
        }
        file := new #.IniFile(filePath)
        data := file.readObject()
        return data
    }

    _isLocked(filePath)
    {
        SplitPath, % filePath,,OutDir
        lockFilePath := #.Path.concat(OutDir, "lockfile")
        return FileExist(lockFilePath)
    }

    _createLock(namespace)
    {
        lockfilePath := this._getLockfilePath(namespace)
        if (!FileExist(lockfilePath)) {
            FileAppend, , % lockfilePath
        }
    }

    _deleteLock(namespace)
    {
        lockfilePath := this._getLockfilePath(namespace)
        if (FileExist(lockfilePath)) {
            FileDelete, % lockfilePath
        }
    }

    _getLockfilePath(namespace)
    {
        return #.Path.concat(this.getNamespacePath(namespace), "lockfile")
    }


    _getUniqueFilename(namespace)
    {
        filePathBase := this.getNamespacePath(namespace)
        FormatTime, dateStr,, % "yyyyMMddHHmmss"
        index := -1
        loop {
            index += 1
            filename := dateStr "-" index ".ini"
            filePath := #.Path.concat(filePathBase, filename)
        } until (!FileExist(filePath))

        return filePath
    }
}