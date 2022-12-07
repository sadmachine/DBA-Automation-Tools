#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include <IniConfig>
#Include <ADOSQL>
#Include <Query>
#include <UI>
#Include <File>
#Include <String>
#Include <DBA>
#Include <Excel>
#Include src/Receiving.ahk
#Include src/Models.ahk

FONT_OPTIONS := {options: "s12", fontName: ""}

UI.Base.defaultFont := FONT_OPTIONS
UI.Base.defaultMargin := 5
UI.MsgBoxObj.defaultWidth := 300

config := new IniConfig("po_verification")

if !(config.exists()) {
    config.copyFrom("po_verification.default.ini")
}

receiver := new Models.Receiver()

receiver.poNumber := UI.RequiredInput("Enter PO #")
receiver.partNumber := UI.RequiredInput("Enter Part #")
receiver.lotNumbers.push(UI.RequiredInput("Enter Lot #"))
receiver.quantities.push(UI.RequiredInput("Enter Quantity"))

verifier := new Receiving.Verify(receiver)

poResults := verifier.GetResults()

recvResults := new Receiving.Results()
recvResults.display(receiver, poResults)

ExitApp

; --- Functions ----------------------------------------------------------------

