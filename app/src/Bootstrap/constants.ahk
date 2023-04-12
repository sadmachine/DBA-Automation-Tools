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
; Revision 4 (04/09/2023)
; * Added various constants, mostly paths
;
; === TO-DOs ===================================================================
; ==============================================================================
Env["APP_PATH"] := Lib.Path.concat(Env["PROJECT_ROOT"], "app")
Env["QUEUE_PATH"] := Lib.Path.concat(Env["APP_ROOT"], "queue")
Env["STORAGE_PATH"] := Lib.Path.concat(Env["APP_PATH"], "storage")
Env["LOGS_PATH"] := Lib.Path.concat(Env["STORAGE_PATH"], "logs")
Env["MODS_PATH"] := Lib.Path.concat(Env["APP_PATH"], "modules")
Env["SETTINGS_INI_FILE"] := Lib.Path.concat(Env["APP_PATH"], "settings.ini")
Env["MODS_INI_FILE"] := Lib.Path.concat(Env["APP_PATH"], "mods.ini")

Env["DOTENV_PATH"]:= Lib.Path.concat(Env["PROJECT_ROOT"], ".env")
if ((exists := FileExist(Env["DOTENV_PATH"])) && !InStr(exists, "D")) {
    dotEnvFile := new Lib.DotEnv(Env["DOTENV_PATH"])
    dotEnvValues := dotEnvFile.toObject()
    for key, value in dotEnvValues {
        Env[key] := value
    }
}