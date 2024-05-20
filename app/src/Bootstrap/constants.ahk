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
; Revision 5 (04/11/2023)
; * Fix QUEUE_PATH location
;
; === TO-DOs ===================================================================
; ==============================================================================
$["APP_PATH"] := #.Path.concat($["PROJECT_ROOT"], "app")
$["QUEUE_PATH"] := #.Path.concat($["APP_PATH"], "queue")
$["STORAGE_PATH"] := #.Path.concat($["APP_PATH"], "storage")
$["LOGS_PATH"] := #.Path.concat($["STORAGE_PATH"], "logs")
$["MODS_PATH"] := #.Path.concat($["APP_PATH"], "modules")
$["SETTINGS_INI_FILE"] := #.Path.concat($["APP_PATH"], "settings.ini")
$["MODS_INI_FILE"] := #.Path.concat($["APP_PATH"], "mods.ini")
$["TEMPLATES_PATH"] := #.Path.concat($["APP_PATH"], "templates")

$["DOTENV_PATH"]:= #.Path.concat($["PROJECT_ROOT"], ".env")
if ((exists := FileExist($["DOTENV_PATH"])) && !InStr(exists, "D")) {
    dotEnvFile := new #.DotEnv($["DOTENV_PATH"])
    dotEnvValues := dotEnvFile.toObject()
    for key, value in dotEnvValues {
        $[key] := value
    }
}