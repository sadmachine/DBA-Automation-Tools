#Include <YUnit/JUnit>
#Include <YUnit/OutputDebug>
#Include <YUnit/StdOut>
#Include <YUnit/Window>
#Include <YUnit/Yunit>

; Include Test Suite files here
; e.g.
;#Include %A_ScriptDir%/tests/TestSuite.ahk
#Include %A_ScriptDir%/tests/DbaSuite.ahk

; Run tests suites here
; e.g.
;Yunit.Use(YunitWindow).Test(TestSuite)
Yunit.Use(YunitWindow).Test(DbaSuite)