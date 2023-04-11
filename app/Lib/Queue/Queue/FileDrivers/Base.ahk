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
; * ... deleteFile
;
; Revision 3 (03/31/2023)
; * Update how files are retrieved
; * Added getNamespacePath()
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Lib.Queue.FileDrivers.Base
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
        queueGlob := Lib.Path.concat(this.getNamespacePath(namespace), "*" this.getFileExtension())
        Loop Files, queueGlob, "F"
        {
            filePaths.push(A_LoopFileFullPath)
        }
        return filePaths
    }

    readFile(filePath)
    {

    }

    deleteFile(filePath)
    {
        FileDelete(filePath)
    }

    getFileExtension()
    {
        ext := Trim(LTrim(this.fileExtension, "."))
        return "." ext
    }

    getNamespacePath(namespace)
    {
        filePathBase := Lib.Path.concat(this.basePath, namespace)
        if (!InStr(FileExist(filePathBase), "D")) {
            Lib.log("queue").info(A_ThisFunc, "Namespace path did not exist, creating it", {namespacePath: filePathBase})
            DirCreate(filePathBase)
        }
        return filePathBase
    }
}