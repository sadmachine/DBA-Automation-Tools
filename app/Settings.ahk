#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

#Include src\Bootstrap.ahk

settingsGui := new UI.Settings("DBA AutoTools Settings")
settingsGui.show()

WinWaitClose, % "DBA AutoTools Settings"
ExitApp