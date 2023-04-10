; === Script Information =======================================================
; Name .........: Installer.ahk
; Description ..: Handles installation/updating of DBA AutoTools
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 01/29/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Installer.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (01/29/2023)
; * Initial creation
; * Create basic installer for Receiving program
; * Get installation location, create directories, install the files
;
; Revision 2 (02/10/2023)
; * Work on Installer GUI
;
; Revision 3 (02/12/2023)
; * Ask for global config location on installation
; * Add more template files on installation
; * Add current program version to config.ini
;
; Revision 4 (03/16/2023)
; * Install QueueManager.exe
;
; Revision 5 (04/10/2023)
; * Don't overwrite certain files on install
;
; === TO-DOs ===================================================================
; TODO - Initialize config files on installation
; TODO - Utilize settings ui to set required values, isntead of dialogs
; TODO - Allow picking of which modules to install
; TODO - Implement a migration/change handling system for updating between versions
; TODO - Detect install vs update
; ==============================================================================

#Include "src/Autoload.ahk"

@.registerExceptionHandler()

GetInstallationLocation()

CreateDirectories()

InstallFiles()

SetupConfigIni()

MsgBox("Finished Installation")

ExitApp()

return

GetInstallationLocation()
{
    Global
    if (!FileExist("C:\DBA Help")) {
        DirCreate("C:\DBA Help")
    }
    installationPath := "C:\DBA Help"
    globalConfigPath := "C:\"

    ; installationGui := new UI.Base("DBA AutoTools Installer")
    ; installationGui.Add("Text", "w460", "Installation Location")
    ; installationGui.Add("Edit", "w400", installationPath)
    ; installationGui.Add("Button", "w400", installationPath)

    installationPath := DirSelect("*" installationPath, 3, "Installation Location")
    if (ErrorLevel) {
        MsgBox("You must supply an installation location to continue. Exiting...")
        ExitApp()
    }

    settingsFilePath := #.Path.concat(installationPath, "DBA AutoTools\app\settings.ini")
    if (FileExist(settingsFilePath)) {
        globalConfigValue := IniRead(settingsFilePath, "location", "global", Config.UNDEFINED)
        if (globalConfigValue == Config.UNDEFINED) {
            globalConfigPath := DirSelect("*" globalConfigPath, 3, "Global Config Path")
            if (ErrorLevel) {
                MsgBox("You must supply a global config path to continue. Exiting...")
                ExitApp()
            }
        } else {
            globalConfigPath := globalConfigValue
        }
    }

    installationPath := RTrim(installationPath, "/\")
}

CreateDirectories()
{
    Global

    projectPath := #.Path.concat(installationPath, "DBA AutoTools")
    appPath := #.Path.concat(projectPath, "app")
    modulesPath := #.Path.concat(appPath, "modules")
    configPath := #.Path.concat(appPath, "config")
    templatesPath := #.Path.concat(appPath, "templates")
    storagePath := #.Path.concat(appPath, "storage")
    logsPath := #.Path.concat(storagePath, "logs")
    queuePath := #.Path.concat(appPath, "queue")

    _CreateDirIfNotExist(projectPath)
    _CreateDirIfNotExist(appPath)
    _CreateDirIfNotExist(modulesPath)
    _CreateDirIfNotExist(configPath)
    _CreateDirIfNotExist(templatesPath)
    _CreateDirIfNotExist(storagePath)
    _CreateDirIfNotExist(logsPath)
    _CreateDirIfNotExist(queuePath)
}

InstallFiles()
{
    Global

    ; Files in project root folder
    FileInstall("..\dist\DBA AutoTools.exe", #.Path.concat(projectPath, "DBA AutoTools.exe"), 1)
    FileInstall("..\dist\QueueManager.exe", #.Path.concat(projectPath, "QueueManager.exe"), 1)
    FileInstall("..\dist\Settings.exe", #.Path.concat(projectPath, "Settings.exe"), 1)
    FileInstall("..\dist\.env", #.Path.concat(projectPath, ".env"), 0)

    ; Files in app folder
    FileInstall("..\dist\app\settings.example.ini", #.Path.concat(appPath, "settings.example.ini"), 1)
    FileInstall("..\dist\app\settings.ini", #.Path.concat(appPath, "settings.ini"), 0)
    FileInstall("..\dist\app\mods.ini", #.Path.concat(appPath, "mods.ini"), 0)

    ; Files in modules folder
    FileInstall("..\dist\app\modules\PO_Verification.exe", #.Path.concat(modulesPath, "PO_Verification.exe"), 1)

    ; Files in templates folder
    FileInstall("..\dist\app\templates\Incoming Inspection Log Template.xlsx", #.Path.concat(templatesPath, "Incoming Inspection Log Template.xlsx"), 1)
    FileInstall("..\dist\app\templates\Incoming Inspection Report Template.xlsx", #.Path.concat(templatesPath, "Incoming Inspection Report Template.xlsx"), 1)
}

SetupConfigIni()
{
    Global
    localConfigPath := configPath
    IniWrite(localConfigPath, #.Path.concat(appPath, "settings.ini"), "location", "local")
    IniWrite(globalConfigPath, #.Path.concat(appPath, "settings.ini"), "location", "global")
}

_CreateDirIfNotExist(path)
{
    if (FileExist(path) != "D") {
        DirCreate(path)
        MsgBox("Created " path)
    }
}