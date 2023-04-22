; === Script Information =======================================================
; Name .........: Config Bootstrapping File
; Description ..: Responsible for bootstrapping the Config class
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/15/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Config.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/15/2023)
; * Added This Banner
;
; Revision 2 (03/27/2023)
; * Use new global var syntax
;
; Revision 3 (04/09/2023)
; * Update messaging for missing config fields
;
; Revision 4 (04/21/2023)
; * Update for ahk v2
; 
; === TO-DOs ===================================================================
; ==============================================================================
if (!FileExist(Env["SETTINGS_INI_FILE"])) {
    throw Core.FilesystemException(A_ThisFunc, "Could not locate the settings.ini file.")
}

Config.BaseField.defaultRequirementValue := true

globalConfigLocation := IniRead(Env["SETTINGS_INI_FILE"], "location", "global")
localConfigLocation := IniRead(Env["SETTINGS_INI_FILE"], "location", "local")

Config.setLocalConfigLocation(localConfigLocation)
Config.setGlobalConfigLocation(globalConfigLocation)
Config.register(DatabaseGroup())
Config.register(ReceivingGroup())

while (!Config.initialized) {
    try {
        Config.initialize()
    } catch Any as e {
        if (Core.typeOf(e) != "Core.RequiredFieldException") {
            throw e
        }
        field := e.field
        previousWidth := UI.MsgBoxObj.defaultWidth
        UI.MsgBoxObj.width := 400
        UI.MsgBox("The config field:`n`n '" field.getFullIdentifier() "'`n`nis required, but missing a value. Please supply a value to continue.`n", "Required Field Missing")
        UI.MsgBoxObj.defaultWidth := previousWidth
        dialog := UI.DialogFactory.fromConfigField(field)
        result := dialog.prompt()
        if (result.canceled) {
            throw e
        }
        field.value := result.value
        field.store(true)
    }
}