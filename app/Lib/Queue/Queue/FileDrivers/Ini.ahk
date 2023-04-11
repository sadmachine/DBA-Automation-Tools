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
; Lib.Queue.FileDrivers.Ini
class Ini extends Lib.Queue.FileDrivers.Base
{
    __New(path)
    {
        base.__New(path, ".ini")
    }

    createFile(namespace, data)
    {
        local file
        filePath := this._getUniqueFilename(namespace)

        file := new Lib.IniFile(filePath)
        file.writeObject(data)
    }

    readFile(filePath)
    {
        local file
        file := new Lib.IniFile(filePath)
        data := file.readObject()
        return data
    }

    _getUniqueFilename(namespace)
    {
        filePathBase := this.getNamespacePath(namespace)
        dateStr := FormatTime(, "yyyyMMddHHmmss")
        index := -1
        Loop{
            index += 1
            filename := dateStr "-" index ".ini"
            filePath := Lib.Path.concat(filePathBase, filename)
        } until (!FileExist(filePath))

        return filePath
    }
}