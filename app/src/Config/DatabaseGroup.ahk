; === Script Information =======================================================
; Name .........: Database Config Group
; Description ..: Configuration group for database settings
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: DatabaseGroup.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
#Include <Config>

class DatabaseGroup extends Config.Group
{
    define()
    {
        this.label := "Database"

        connectionFile := new Config.File("Connection")

        mainSection := new Config.Section("Main")
        mainSection.add(new Config.StringField("DSN")
            .setScope(Config.Scope.LOCAL)
            .setDescription("The ODBC identifier for the database connection."))

        connectionFile.add(mainSection)
        this.add(connectionFile)
    }
}