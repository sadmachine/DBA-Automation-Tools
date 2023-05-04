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
    outputHandler := ""
    encoding := "UTF-8"

    setEncoding(encoding)
    {
        this.encoding := encoding
    }

    setOutputHandler(outputHandler)
    {
        this.outputHandler := outputHandler
    }

    exec(command, finishedCallback := "")
    {
        static HANDLE_FLAG_INHERIT := 0x00000001, flags := HANDLE_FLAG_INHERIT
            , STARTF_USESTDHANDLES := 0x100, CREATE_NO_WINDOW := 0x08000000
        DllCall("CreatePipe", "PtrP", hPipeRead, "PtrP", hPipeWrite, "Ptr", 0, "UInt", 0)
        DllCall("SetHandleInformation", "Ptr", hPipeWrite, "UInt", flags, "UInt", HANDLE_FLAG_INHERIT)

        VarSetCapacity(STARTUPINFO , siSize := A_PtrSize*4 + 4*8 + A_PtrSize*5, 0)
        NumPut(siSize , STARTUPINFO)
        NumPut(STARTF_USESTDHANDLES, STARTUPINFO, A_PtrSize*4 + 4*7)
        NumPut(hPipeWrite , STARTUPINFO, A_PtrSize*4 + 4*8 + A_PtrSize*3)
        NumPut(hPipeWrite , STARTUPINFO, A_PtrSize*4 + 4*8 + A_PtrSize*4)

        VarSetCapacity(PROCESS_INFORMATION, A_PtrSize*2 + 4*2, 0)

        createProcess := "CreateProcess"
        if (A_IsUnicode) {
            createProcess := "CreateProcessW"
        }

        if (DllCall(createProcess, "Ptr", 0, "Str", ComSpec " /c " command, "Ptr", 0, "Ptr", 0, "UInt", true, "UInt", CREATE_NO_WINDOW
            , "Ptr", 0, "Ptr", 0, "Ptr", &STARTUPINFO, "Ptr", &PROCESS_INFORMATION) <= 0)
        {
            DllCall("CloseHandle", "Ptr", hPipeRead)
            DllCall("CloseHandle", "Ptr", hPipeWrite)
            throw Exception("CreateProcess is failed, " A_LastError)
        }
        DllCall("CloseHandle", "Ptr", hPipeWrite)
        VarSetCapacity(sTemp, 4096), nSize := 0
        while DllCall("ReadFile", "Ptr", hPipeRead, "Ptr", &sTemp, "UInt", 4096, "UIntP", nSize, "UInt", 0) {
            sOutput .= stdOut := StrGet(&sTemp, nSize, this.encoding)
            ( this.outputHandler && this.outputHandler.Call(stdOut) )
        }
        DllCall("CloseHandle", "Ptr", NumGet(PROCESS_INFORMATION))
        DllCall("CloseHandle", "Ptr", NumGet(PROCESS_INFORMATION, A_PtrSize))
        DllCall("CloseHandle", "Ptr", hPipeRead)

        (finishedCallback && finishedCallback.Call())
        Return sOutput
    }
    ; exec(command)
    ; {
    ;     RunWait, % comspec " /S /C """ command """", UseErrorLevel

    ;     if (ErrorLevel = "ERROR") {
    ;         throw new @.UnexpectedException("CommandException", A_ThisFunc, "The command '" command "' was unable to run.")
    ;     }
    ; }

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
                    return -1
                }
            } else if (fileAttrs) {
                return -1
            }
        }

        return this.exec("echo F|xcopy /H /Y /I """ path1 """ """ path2 """")
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
                    return -1
                }
            } else if (fileAttrs) {
                return -1
            }
        }

        return this.exec("echo F|xcopy /Y /I """ path1 """ """ path2 """ && del """ path1 """")
    }

    del(path)
    {
        return this.exec("del """ path """")
    }

    attrib(attribs, path)
    {
        path := #.Path.normalize(path)
        if (!FileExist(path)) {
            throw new @.FilesystemException(A_ThisFunc, "The Path '" path "' did not exist, and so it could not be edited.")
        }

        return this.exec("attrib " attribs " """ path """")
    }
}
