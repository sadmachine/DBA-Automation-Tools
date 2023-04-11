; === Script Information =======================================================
; Name .........: Test Suite Entrypoint
; Description ..: Allows for running of various test suites
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: tests.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; TODO - Write more tests
; ==============================================================================
#Include <YUnit/JUnit>
#Include <YUnit/OutputDebug>
#Include <YUnit/Stdout>
#Include <YUnit/Window>
#Include <YUnit/Yunit>

; Include Test Suite files here
; e.g.
;#Include %A_ScriptDir%/tests/TestSuite.ahk
#Include "tests/DbaTests.ahk"
#Include "tests/ConfigTests.ahk"
#Include "tests/CoreTests.ahk"

; Run tests suites here
; e.g.
;Yunit.Use(YunitWindow).Test(TestSuite)
Yunit.Use(YunitWindow).Test(CoreTests)
