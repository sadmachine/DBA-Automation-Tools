; === Script Information =======================================================
; Name .........: Migrations parent class
; Description ..: Class to hold migrations/migration related classes
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 05/08/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Migrations.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (05/08/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================

class Migrations {
  #Include src/Migrations/BaseChange.ahk
  #Include src/Migrations/BaseMigration.ahk
  #Include src/Migrations/InstallChanges.ahk
  #Include src/Migrations/UpdateChanges.ahk
}