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
; ==============================================================================

; === TO-DOs ===================================================================
; TODO - Initialize config files on installation
; TODO - Allow picking of which modules to install
; TODO - Implement a migration/change handling system for updating between versions
; TODO - Detect install vs update
; ==============================================================================

#Include src/Bootstrap.ahk

GetInstallationLocation()

CreateDirectories()

InstallFiles()

MsgBox % "Finished Installation"

return

GetInstallationLocation()
{
    Global
    if (!FileExist("C:\DBA Help")) {
        FileCreateDir, % "C:\DBA Help"
    }
    installationPath := "C:\DBA Help"

    installationGui := new UI.Base("DBA AutoTools Installer")
    installationGui.Add("Text", "w460", "Installation Location")
    installationGui.Add("Edit", "w400", installationPath)
    installationGui.Add("Text", "w400", installationPath)

    FileSelectFolder, installationPath, *%installationPath%, 3

    installationPath := RTrim(installationPath, "/\")
}

CreateDirectories()
{
    Global

    modulesPath := @File.concat(installationPath, "modules")
    configPath := @File.concat(modulesPath, "config")
    templatesPath := @File.concat(modulesPath, "templates")

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
    FileInstall, dist\DBA AutoTools.exe, % @File.concat(installationPath, "DBA AutoTools.exe"), 1
    FileInstall, dist\Settings.exe, % @File.concat(installationPath, "Settings.exe"), 1
    FileInstall, dist\modules\PO_Verification.exe, % @File.concat(modulesPath, "PO_Verification.exe"), 1
    FileInstall, dist\modules\config.example.ini, % @File.concat(modulesPath, "config.example.ini"), 1
    FileInstall, dist\modules\mods.ini, % @File.concat(modulesPath, "mods.ini"), 1
    FileInstall, dist\modules\templates\Incoming Inspection Log Template.xlsx, % @File.concat(templatesPath, "Incoming Inspection Log Template.xlsx"), 1
    FileInstall, dist\modules\templates\Incoming Inspection Report Template.xlsx, % @File.concat(templatesPath, "Incoming Inspection Report Template.xlsx"), 1
}
