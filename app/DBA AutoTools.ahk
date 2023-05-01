; === Script Information =======================================================
; Name .........: DBA Automation Tools
; Description ..: Set of general automation tools for DBA Manufacturing
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
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
;
; Revision 2 (03/07/2023)
; * Remove redundant imports
;
; Revision 3 (03/15/2023)
; * Run queue manager on startup
;
; Revision 4 (03/16/2023)
; * Run queue manager on an interval
;
; Revision 5 (03/26/2023)
; * Use global var with a different syntax
;
; Revision 6 (04/09/2023)
; * Update to use MODS_PATH global variable
;
; Revision 7 (04/30/2023)
; * Add additional logging
;
; === TO-DOs ===================================================================
; TODO - Use Bootstrap.ahk
; ==============================================================================

#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#Persistent
#SingleInstance force

; --- Includes -----------------------------------------------------------------
#Include src\Bootstrap.ahk
#Include src\ModuleLoader.ahk
#Include src\Dashboard.ahk

ModuleLoader.boot($["MODS_PATH"], $["MODS_INI_FILE"])
Dashboard.initialize()
;initialize_hub_gui()

SetTimer, RunQueueManager, 1000

Return

; --- Labels -------------------------------------------------------------------

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
    #.log("app").info(A_ThisFunc, "Launch module: " module_title)
    mod := ModuleLoader.get(module_title)
    Run % $["MODS_PATH"] "/" ModuleLoader.get(module_title).file
}

RunQueueManager()
{
    Global
    Process, Exist, QueueManager.exe
    if (!ErrorLevel) {
        #.log("app").info(A_ThisFunc, "QueueManager.exe process not found, launching")
        Run, % #.path.concat($["PROJECT_ROOT"], "QueueManager.exe")
    }
}
