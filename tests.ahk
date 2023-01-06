#Include <YUnit/JUnit>
#Include <YUnit/OutputDebug>
#Include <YUnit/Stdout>
#Include <YUnit/Window>
#Include <YUnit/Yunit>

; Include Test Suite files here
; e.g.
;#Include %A_ScriptDir%/tests/TestSuite.ahk
#Include %A_ScriptDir%/tests/DbaTests.ahk
#Include %A_ScriptDir%/tests/ConfigTests.ahk

; Run tests suites here
; e.g.
;Yunit.Use(YunitWindow).Test(TestSuite)
Yunit.Use(YunitWindow).Test(ConfigTests)
