; === Script Information =======================================================
; Name .........: Bootstrap Script
; Description ..: Includes common libraries/files and configures them
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Bootstrap.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; TODO - Clean/Organize better
; ==============================================================================
#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

#Include <@>
#Include <#>
#Include <ADOSQL>
#Include <Config>
#Include <DBA>
#Include <Excel>
#Include <Query>
#Include <String>
#include <UI>
#Include src/Models.ahk
#Include src/Controllers.ahk
#Include src/Views.ahk
#Include src/Actions.ahk
#Include src/Config/All.ahk

CURRENT_VERSION := "0.9.0"

@.registerExceptionHandler()

if (!IS_INSTALLATION) {
    PROJECT_ROOT := ""
    if (InStr("DBA AutoTools.exe,Settings.exe,Installer.exe", A_ScriptName)) {
        PROJECT_ROOT := #.Path.normalize(A_ScriptDir)
    } else {
        PROJECT_ROOT := #.Path.parentOf(A_ScriptDir)
    }

    configIniLocation := #.Path.concat(PROJECT_ROOT, "modules\config.ini")

    if (!FileExist(configIniLocation)) {
        throw new @.FilesystemException(A_ThisFunc, "Could not locate the config.ini file.")
    }

    UI.Base.defaultFont := {options: "S12", fontName: ""}
    Config.BaseField.defaultRequirementValue := true

    IniRead, globalConfigLocation, % configIniLocation, % "location", % "global"
    IniRead, localConfigLocation, % configIniLocation, % "location", % "local"
    Config.setLocalConfigLocation(localConfigLocation)
    Config.setGlobalConfigLocation(globalConfigLocation)
    Config.register(new DatabaseGroup())
    Config.register(new ReceivingGroup())

    while (!Config.initialized) {
        try {
            Config.initialize()
        } catch e {
            if (@.typeOf(e) != "@.RequiredFieldException") {
                throw e
            }
            field := e.field
            previousWidth := UI.MsgBoxObj.width
            UI.MsgBoxObj.width := 400
            UI.MsgBox("The config field '" field.getFullIdentifier() "' is required, but missing a value. Please supply a value to continue.", "Required Field Missing")
            UI.MsgBoxObj.width := previousWidth
            dialog := UI.DialogFactory.fromConfigField(field)
            result := dialog.prompt()
            if (result.canceled) {
                throw e
            }
            field.value := result.value
            field.store(true)
        }
    }

    DBA.DbConnection.DSN := Config.get("database.connection.main.dsn")

    #.Logger.setLocation(#.Path.concat(PROJECT_ROOT, "modules\"))
    #.Logger.info(A_ThisFunc, "Finished Bootstrapping '" A_ScriptName "'")
}