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
        static HANDLE_FLAG_INHERIT := 0x00000001, flags := HANDLE_FLAG_INHERIT            , STARTF_USESTDHANDLES := 0x100, CREATE_NO_WINDOW := 0x08000000
        DllCall("CreatePipe", "PtrP", &hPipeRead, "PtrP", &hPipeWrite, "Ptr", 0, "UInt", 0)
        DllCall("SetHandleInformation", "Ptr", hPipeWrite, "UInt", flags, "UInt", HANDLE_FLAG_INHERIT)

        STARTUPINFO := Buffer(siSize := A_PtrSize*4 + 4*8 + A_PtrSize*5, 0) ; V1toV2: if 'STARTUPINFO' is a UTF-16 string, use 'VarSetStrCapacity(&STARTUPINFO, siSize := A_PtrSize*4 + 4*8 + A_PtrSize*5)'
        NumPut("UPtr", siSize, STARTUPINFO)
        NumPut(A_PtrSize*4 + 4*7, STARTF_USESTDHANDLES, STARTUPINFO)
        NumPut(A_PtrSize*4 + 4*8 + A_PtrSize*3, hPipeWrite, STARTUPINFO)
        NumPut(A_PtrSize*4 + 4*8 + A_PtrSize*4, hPipeWrite, STARTUPINFO)

        PROCESS_INFORMATION := Buffer(A_PtrSize*2 + 4*2, 0) ; V1toV2: if 'PROCESS_INFORMATION' is a UTF-16 string, use 'VarSetStrCapacity(&PROCESS_INFORMATION, A_PtrSize*2 + 4*2)'

        createProcess := "CreateProcess"
        if (1) {
            createProcess := "CreateProcessW"
        }

        if (DllCall(createProcess, "Ptr", 0, "Str", A_ComSpec " /c " command, "Ptr", 0, "Ptr", 0, "UInt", true, "UInt", CREATE_NO_WINDOW, "Ptr", 0, "Ptr", 0, "Ptr", STARTUPINFO, "Ptr", PROCESS_INFORMATION) <= 0)
        {
            DllCall("CloseHandle", "Ptr", hPipeRead)
            DllCall("CloseHandle", "Ptr", hPipeWrite)
            throw Exception("CreateProcess is failed, " A_LastError)
        }
        DllCall("CloseHandle", "Ptr", hPipeWrite)
        VarSetStrCapacity(&sTemp, 4096), nSize := 0 ; V1toV2: if 'sTemp' is NOT a UTF-16 string, use 'sTemp := Buffer(4096)'
        while DllCall("ReadFile", "Ptr", hPipeRead, "Ptr", sTemp, "UInt", 4096, "UIntP", &nSize, "UInt", 0) {
            sOutput .= stdOut := StrGet(&sTemp, nSize, this.encoding)
            ( this.outputHandler && this.outputHandler.Call(stdOut) )
        }
        DllCall("CloseHandle", "Ptr", NumGet(PROCESS_INFORMATION, "UPtr"))
        DllCall("CloseHandle", "Ptr", NumGet(PROCESS_INFORMATION, A_PtrSize, "UPtr"))
        DllCall("CloseHandle", "Ptr", hPipeRead)

        (finishedCallback && finishedCallback.Call())
        Return sOutput
    }
    ; exec(command)
    ; {
    ;     RunWait, % comspec " /S /C """ command """", UseErrorLevel

    ;     if (ErrorLevel = "ERROR") {
    ;         throw new Core.UnexpectedException("CommandException", A_ThisFunc, "The command '" command "' was unable to run.")
    ;     }
    ; }

    copy(path1, path2, overwrite := true)
    {
        if (!FileExist(path1)) {
            throw new Core.FilesystemException(A_ThisFunc, "The Path '" path1 "' did not exist, and so it could not be copied.")
        }
        path1 := Lib.Path.normalize(path1)
        path2 := Lib.Path.normalize(path2)
        if (!overwrite) {
            fileAttrs := FileExist(path2)
            if (InStr(fileAttrs, "D")) {
                newFilename := Lib.Path.parseFilename(path1)
                fullPath := Lib.Path.concat(path2, newFilename)
                if (FileExist(fullPath)) {
                    return -1
                }
            } else if (fileAttrs) {
                return -1
            }
        }

        return this.exec('echo F|xcopy /H /Y /I "' path1 '" "' path2 '"')
    }

    move(path1, path2, overwrite := true)
    {
        if (!FileExist(path1)) {
            throw new Core.FilesystemException(A_ThisFunc, "The Path '" path1 "' did not exist, and so it could not be copied.")
        }
        path1 := Lib.Path.normalize(path1)
        path2 := Lib.Path.normalize(path2)
        if (!overwrite) {
            fileAttrs := FileExist(path2)
            if (InStr(fileAttrs, "D")) {
                newFilename := Lib.Path.parseFilename(path1)
                fullPath := Lib.Path.concat(path2, newFilename)
                if (FileExist(fullPath)) {
                    return -1
                }
            } else if (fileAttrs) {
                return -1
            }
        }

        return this.exec('echo F|xcopy /H /Y /I "' path1 '" "' path2 '" && del /AH "' path1 '"')
    }

    attrib(attribs, path)
    {
        path := Lib.Path.normalize(path)
        if (!FileExist(path)) {
            throw new Core.FilesystemException(A_ThisFunc, "The Path '" path "' did not exist, and so it could not be edited.")
        }

        return this.exec('attrib ' attribs ' "' path '"')
    }
}
