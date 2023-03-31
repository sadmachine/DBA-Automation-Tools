; === Script Information =======================================================
; Name .........: Constants
; Description ..: A file containing all runtime constant declarations
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/15/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Constants.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/15/2023)
; * Added This Banner
;
; Revision 2 (03/27/2023)
; * Use new global var syntax
;
; Revision 3 (03/31/2023)
; * Add .env file support for adding global vars
;
; === TO-DOs ===================================================================
; ==============================================================================

$["PROJECT_ROOT"] := ""
if (InStr("DBA AutoTools.exe,QueueManager.exe,Settings.exe,Installer.exe", A_ScriptName)) {
    $["PROJECT_ROOT"] := #.Path.normalize(A_ScriptDir)
} else {
    $["PROJECT_ROOT"] := #.Path.parentOf(A_ScriptDir)
}

$["QUEUE_PATH"] := #.Path.concat($["PROJECT_ROOT"], "queue")
if (!InStr(FileExist($["QUEUE_PATH"]), "D")) {
    FileCreateDir % $["QUEUE_PATH"]
}

dotEnvPath := #.Path.concat($["PROJECT_ROOT"], ".env")
if (InStr("AN", FileExist(dotEnvPath))) {
    dotEnvFile := new #.DotEnv(dotEnvPath)
    dotEnvValues := dotEnvFile.toObject()
    for key, value in dotEnvValues {
        $[key] := value
    }
}