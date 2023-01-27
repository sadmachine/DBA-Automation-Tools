#NoEnv
#SingleInstance, Force
#Persistent
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

#Include <DBA>
#Include <UI>

settings := new UI.Settings("Test settings")
settings.Show()