#Include <@>
#Include <Config>
#Include <ADOSQL>
#Include <Query>
#include <UI>
#Include <@File>
#Include <String>
#Include <DBA>
#Include <Excel>
#Include src/Models.ahk
#Include src/Controllers.ahk
#Include src/Views.ahk
#Include src/Actions.ahk
#Include src/Config/All.ahk

@.registerExceptionHandler()

UI.Base.defaultFont := {options: "S12", fontName: ""}
Config.BaseField.defaultRequirementValue := true

IniRead, globalConfigLocation, % @File.parseDirectory(A_LineFile) "/config.ini", % "location", % "global"
IniRead, localConfigLocation, % @File.parseDirectory(A_LineFile) "/config.ini", % "location", % "local"
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
