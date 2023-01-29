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

#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

#Include <@File>

GetInstallationLocation()

CreateDirectories()

InstallFiles()

MsgBox % "Finished Installation"

return

GetInstallationLocation()
{
    Global
    installationPath := A_MyDocuments

    FileSelectFolder, installationPath, *%installationPath%, 3

    installationPath := RTrim(installationPath, "/\")
    MsgBox % installationPath
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
    FileInstall, dist\modules\PO_Verification.exe, % @File.concat(modulesPath, "PO_Verification.exe"), 1
    FileInstall, dist\modules\config.example.ini, % @File.concat(modulesPath, "config.example.ini"), 1
    FileInstall, dist\modules\mods.ini, % @File.concat(modulesPath, "mods.ini"), 1
    FileInstall, dist\modules\templates\Incoming Inspection Log.xlsx, % @File.concat(templatesPath, "Incoming Inspection Log.xlsx"), 1
}