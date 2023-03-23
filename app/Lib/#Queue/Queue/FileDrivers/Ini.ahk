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
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; #.Queue.FileDrivers.Ini
class Ini extends #.Queue.FileDrivers.Base
{
    createFile(namespace, data)
    {
        local file
        filePath := this._getUniqueFilename(namespace)

        file := #.IniFile(filePath)
        file.writeObject(data)
    }

    retrieveFiles(namespace)
    {

    }

    _getUniqueFilename(namespace)
    {
        filePathBase := #.Path.concat(this.basePath, namespace)
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