; === Script Information =======================================================
; Name .........: Settings Editor
; Description ..: Opens a GUI for editing config files
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Settings.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; Revision 2 (04/19/2023)
; * Update for ahk v2
; 
; === TO-DOs ===================================================================
; ==============================================================================
#Include "src\Bootstrap.ahk"

settingsGui := UI.Settings("DBA AutoTools Settings")
settingsGui.show()
settingsGui.WaitClose()

ExitApp()

