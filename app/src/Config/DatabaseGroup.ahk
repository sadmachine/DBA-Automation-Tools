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
; Revision 2 (04/21/2023)
; * Update for ahk v2
; 
; === TO-DOs ===================================================================
; ==============================================================================

class DatabaseGroup extends Config.Group
{
    define()
    {
        this.label := "Database"

        connectionFile := Config.File("Connection")

        mainSection := Config.Section("Main")
        mainSection.add(Config.StringField("DSN")
            .setScope(Config.Scope.LOCAL)            
            .setDescription("The ODBC identifier for the database connection."))

        connectionFile.add(mainSection)
        this.add(connectionFile)
    }
}