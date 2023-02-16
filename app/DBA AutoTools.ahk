; === Script Information =======================================================
; Name .........: DBA Automation Tools
; Description ..: Set of general automation tools for DBA Manufacturing
; AHK Version ..: 1.1.32.00 (Unicode 64-bit)
; Start Date ...: 09/02/2022
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: DBA AutoTools.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (09/02/2022)
; * Initial creation
; * Add basic structure of file
; * Setup prototype of main hub gui overlay
; * Initial prototype of module loading system
; ==============================================================================

#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#Persistent
#SingleInstance force

; --- Includes -----------------------------------------------------------------
#Include <DBA>
#Include <UI>

#Include src\ModuleLoader.ahk
#Include src\Dashboard.ahk
#Include src\Bootstrap.ahk

; --- Global var setup ---------------------------------------------------------

; Whether or not debug mode is active
DEBUG_MODE := false
; The folder where modules can be found
MODS_FOLDER := A_ScriptDir "/modules"

; --- Setup steps --------------------------------------------------------------

for n, param in A_Args
{
    if (param == "-d")
    {
        DEBUG_MODE := true
    }

    if (InStr(param, "--module-location="))
    {
        parts := StrSplit(param, "=")
        location := Trim(parts[2], OmitChars = "/")
        MODS_FOLDER := "/" parts[2]
    }
}

#.Logger.info(A_LineFile, "`DEBUG_MODE` = " DEBUG_MODE)
#.Logger.info(A_LineFile, "`MODS_FOLDER` = " MODS_FOLDER)

ModuleLoader.boot(MODS_FOLDER)
Dashboard.initialize()
;initialize_hub_gui()

Return

; --- Labels -------------------------------------------------------------------

RunUtility:

return

; --- Functions ----------------------------------------------------------------

/**
 *  Creates an overlay GUI when the "Closed Job Cost Summary" window is found.
 *  The overlay GUI is styled to look like its part of the DBA window, adding a
 *  button and some text. The GUI's parent is set to the DBA Window as well.
*/

LaunchModule(CtrlHwnd, GuiEvent, EventInfo, ErrLevel := "")
{
    Global
    GuiControlGet, module_title,, % CtrlHwnd
    mod := ModuleLoader.get(module_title)
    Run % MODS_FOLDER "/" ModuleLoader.get(module_title).file
}
