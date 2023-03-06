; === Script Information =======================================================
; Name .........: Cmd
; Description ..: Command Prompt program helper
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/05/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Cmd.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/05/2023)
; * Added This Banner
; * Add exec, copy, move commands
;
; === TO-DOs ===================================================================
; ==============================================================================
class Cmd
{
    exec(command)
    {
        RunWait, % comspec " /S /C """ command """"

        if (ErrorLevel = "ERROR") {
            throw new @.UnexpectedException("CommandException", A_ThisFunc, "The command '" command "' was unable to run.")
        }
    }

    copy(path1, path2, overwrite := true)
    {
        if (!FileExist(path1)) {
            throw new @.FilesystemException(A_ThisFunc, "The Path '" path1 "' did not exist, and so it could not be copied.")
        }
        path1 := #.Path.normalize(path1)
        path2 := #.Path.normalize(path2)
        if (!overwrite) {
            fileAttrs := FileExist(path2)
            if (InStr(fileAttrs, "D")) {
                newFilename := #.Path.parseFilename(path1)
                fullPath := #.Path.concat(path2, newFilename)
                if (FileExist(fullPath)) {
                    return false
                }
            } else if (fileAttrs) {
                return false
            }
        }

        this.exec("echo F|xcopy /H /Y /I """ path1 """ """ path2 """")
        return true
    }

    move(path1, path2, overwrite := true)
    {
        if (!FileExist(path1)) {
            throw new @.FilesystemException(A_ThisFunc, "The Path '" path1 "' did not exist, and so it could not be copied.")
        }
        path1 := #.Path.normalize(path1)
        path2 := #.Path.normalize(path2)
        if (!overwrite) {
            fileAttrs := FileExist(path2)
            if (InStr(fileAttrs, "D")) {
                newFilename := #.Path.parseFilename(path1)
                fullPath := #.Path.concat(path2, newFilename)
                if (FileExist(fullPath)) {
                    return false
                }
            } else if (fileAttrs) {
                return false
            }
        }

        this.exec("echo F|xcopy /H /Y /I """ path1 """ """ path2 """ && del /AH """ path1 """")
        return true
    }

    attrib(attribs, path)
    {
        path := #.Path.normalize(path)
        if (!FileExist(path)) {
            throw new @.FilesystemException(A_ThisFunc, "The Path '" path "' did not exist, and so it could not be edited.")
        }

        this.exec("attrib " attribs " """ path """")
        return true
    }
}