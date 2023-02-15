#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

#Include src\Bootstrap.ahk

settingsGui := new UI.Settings("DBA AutoTools Settings")
settingsGui.show()

GuiClose(guiHwnd)
{
    global
    if (guiHwnd == settingsGui.hwnd) {
        ExitApp
    }
}
WinWaitClose, % "DBA AutoTools Settings"
ExitApp