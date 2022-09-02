; === Script Information =======================================================
; Name .........: DBA Automation Tools
; Description ..: Set of general automation tools for DBA Manufacturing
; AHK Version ..: 1.1.32.00 (Unicode 64-bit)
; Start Date ...: 09/02/2022
; OS Version ...: DBA.Windows 10
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
#Warn ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#Persistent

; --- Includes -----------------------------------------------------------------
#Include <DBA>

; --- Global var setup ---------------------------------------------------------

; Whether or not debug mode is active
DEBUG_MODE     := false
; The folder where modules can be found
MODS_FOLDER    := A_ScriptDir "/modules"
; Will be used to hold a list of available modules to load
AVAILABLE_MODS := []

; --- Setup steps --------------------------------------------------------------

for n, param in A_Args
{
    if (param == "-d") 
    {
        DEBUG_MODE := true
    }

    if (InStr(param, "--module-location=")) 
    {
        parts       := StrSplit(param, "=")
        location    := Trim(parts[2], OmitChars = "/")
        MODS_FOLDER := "/" parts[2]
    }
}

load_modules()
;initialize_hub_gui()

Return

; --- Labels -------------------------------------------------------------------

RunUtility:

return

; --- Functions ----------------------------------------------------------------  

load_modules() 
{
    Global
    Loop, Files, % MODS_FOLDER "/*"
    {
        parts       := StrSplit(A_LoopFileName, ".")
        module_name := StrReplace(parts[1], "-", " ")
        MsgBox % module_name
    }
}

/**
 *  Creates an overlay GUI when the "Closed Job Cost Summary" window is found.
 *  The overlay GUI is styled to look like its part of the DBA window, adding a
 *  button and some text. The GUI's parent is set to the DBA Window as well.
*/
initialize_hub_gui()
{
    Global
    ; Wait for the "Sub-Assy Jobs" screen to be active
    WinActivate, % DBA.Windows.Main
    WinWaitActive, % DBA.Windows.Main

    width := 500
    height := 320
    vertical_fix := 65 
    padding := 20

    ; Get a reference to the "parent" window 
    hParent := WinExist(DBA.Windows.Main)
    WinGetPos,,,main_width, main_height, % DBA.Windows.Main

    display_x := 234 + padding
    display_y := 74

    ; Build and Display the overlay
    Gui, overlay:Margin, 0, 0
    Gui, overlay:Font, S12
    Gui, overlay:Add, GroupBox, w%width% h%height% -border, Automation Tools
    Gui, overlay: +OwnDialogs +AlwaysOnTop -Caption HWNDhChild
    Gui, overlay:Show, x%display_x% y%display_y%, 

    ; Need to set the parent of the gui to the "DBA NG Sub-Assy Jobs" program
    ; This makes it so our overlay moves with the parent window, and acts like its part of the program
    DllCall("SetParent", Ptr, hChild, Ptr, hParent)
}

