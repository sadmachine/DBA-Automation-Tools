#Include <YUnit/JUnit>
#Include <YUnit/OutputDebug>
#Include <YUnit/StdOut>
#Include <YUnit/Window>
#Include <YUnit/Yunit>
#Include %A_ScriptDir%/tests/ConfigSuite.ahk

Yunit.Use(YunitWindow).Test(ConfigSuite)