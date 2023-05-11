; === Script Information =======================================================
; Name .........: Create Directories
; Description ..: Create directories necessary for installation
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 05/09/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: CreateDirectories.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (05/09/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Migrations.v0_10_5.Install.CreateDirectories
class CreateDirectories extends Migrations.BaseChange
{
    do()
    {
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

    undo()
    {

    }

    _createDirIfNotExist(path)
    {

    }
}