#Include <@>
#Include <@File>
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

@.registerExceptionHandler()

UI.Base.defaultFont := {options: "S12", fontName: ""}
Config.BaseField.defaultRequirementValue := true

if (FileExist("C:\DBA Help\DBA Autotools") == "D") {
    configIniLocation := "C:\DBA Help\DBA Autotools\modules\config.ini"
} else {
    configIniLocation := @File.parseDirectory(A_LineFile) "/config.ini"
    if (!FileExist(configIniLocation)) {
        configIniLocation := @File.parseDirectory(A_LineFile) "/modules/config.ini"
    }
    if (!FileExist(configIniLocation)) {
        throw new @.FilesystemException("Could not locate the config.ini file.")
    }
}

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
