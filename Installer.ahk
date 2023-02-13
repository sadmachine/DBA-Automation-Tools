; === Script Information =======================================================
; Name .........: Installer.ahk
; Description ..: Handles installation/updating of DBA AutoTools
; AHK Version ..: 1.1.32.00 (Unicode 64-bit)
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
; Revision 2 (02/10/2023)
; * Work on Installer GUI
; 
; ==============================================================================

; === TO-DOs ===================================================================
; TODO - Initialize config files on installation
; TODO - Utilize settings ui to set required values, isntead of dialogs
; TODO - Allow picking of which modules to install
; TODO - Implement a migration/change handling system for updating between versions
; TODO - Detect install vs update
; ==============================================================================

#Include src/Bootstrap.ahk

GetInstallationLocation()

CreateDirectories()

InstallFiles()

SetupConfigIni()

MsgBox % "Finished Installation"

return

GetInstallationLocation()
{
    Global
    if (!FileExist("C:\DBA Help")) {
        FileCreateDir, % "C:\DBA Help"
    }
    installationPath := "C:\DBA Help"
    globalConfigPath := "C:\"

    installationGui := new UI.Base("DBA AutoTools Installer")
    installationGui.Add("Text", "w460", "Installation Location")
    installationGui.Add("Edit", "w400", installationPath)
    installationGui.Add("Button", "w400", installationPath)

    FileSelectFolder, installationPath, *%installationPath%, 3, % "Installation Location"
    FileSelectFolder, globalConfigPath, *%globalConfigPath%, 3, % "Global Config Path"

    installationPath := RTrim(installationPath, "/\")
}

CreateDirectories()
{
    Global

    modulesPath := #.Path.concat(installationPath, "modules")
    configPath := #.Path.concat(modulesPath, "config")
    templatesPath := #.Path.concat(modulesPath, "templates")

    if (FileExist(modulesPath) != "D") {
        FileCreateDir % modulesPath
        MsgBox % "Created " modulesPath
    }

    if (FileExist(configPath) != "D") {
        FileCreateDir % configPath
        MsgBox % "Created " configPath
    }

    if (FileExist(templatesPath) != "D") {
        FileCreateDir % templatesPath
        MsgBox % "Created " templatesPath
    }
}

InstallFiles()
{
    Global
    FileInstall, dist\DBA AutoTools.exe, % #.Path.concat(installationPath, "DBA AutoTools.exe"), 1
    FileInstall, dist\Settings.exe, % #.Path.concat(installationPath, "Settings.exe"), 1
    FileInstall, dist\modules\PO_Verification.exe, % #.Path.concat(modulesPath, "PO_Verification.exe"), 1
    FileInstall, dist\modules\config.example.ini, % #.Path.concat(modulesPath, "config.example.ini"), 1
    FileInstall, dist\modules\mods.ini, % #.Path.concat(modulesPath, "mods.ini"), 1
    FileInstall, dist\modules\templates\Incoming Inspection Log Template.xlsx, % #.Path.concat(templatesPath, "Incoming Inspection Log Template.xlsx"), 1
    FileInstall, dist\modules\templates\Incoming Inspection Report Template.xlsx, % #.Path.concat(templatesPath, "Incoming Inspection Report Template.xlsx"), 1
}

SetupConfigIni()
{
    Global
    localConfigPath := configPath
    IniWrite, % localConfigPath, % @File.concat(modulesPath, "config.ini"), % "location", % "local"
    IniWrite, % globalConfigPath, % @File.concat(modulesPath, "config.ini"), % "location", % "global"
}
