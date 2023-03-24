; === Script Information =======================================================
; Name .........: Base File Driver
; Description ..: A base file driver for other file drivers to extend
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/20/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Base.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/20/2023)
; * Added This Banner
;
; Revision 2 (03/23/2023)
; * Updated api, fileExtension, getFileExtension, retrieveFiles, readFile
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; #.Queue.FileDrivers.Base
class Base
{
    basePath := ""
    fileExtension := ""

    __New(path, extension)
    {
        this.basePath := path
        this.fileExtension := extension
    }

    createFile(namespace, data)
    {

    }

    retrieveFiles(namespace)
    {
        filePaths := []
        queueGlob := "*" this.getFileExtension()
        queuePath := #.Path.concat(this.basePath, namespace)
        Loop, Files, % #.path.concat(queuePath, queueGlob), F
        {
            this.filePaths.push(A_LoopFileLongPath)
        }
        return filePaths
    }

    readFile(filePath)
    {

    }

    deleteFile(filePath)
    {
        FileDelete % filePath
    }

    getFileExtension()
    {
        ext := Trim(LTrim(this.fileExtension, "."))
        return "." ext
    }
}