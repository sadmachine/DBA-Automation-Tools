; === Script Information =======================================================
; Name .........: Dateabase Bootstrap file
; Description ..: Responsible for bootstrapping the database
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/15/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Database.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/15/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
DBA.DbConnection.DSN := Config.get("database.connection.main.dsn")