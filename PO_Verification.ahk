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

FONT_OPTIONS := {options: "s12", fontName: ""}

UI.Base.defaultFont := FONT_OPTIONS
UI.Base.defaultMargin := 5

config := new IniConfig("po_verification")

if !(config.exists()) {
    config.copyFrom("po_verification.default.ini")
}

receiver := new Receiving.Receiver()

receiver.RequestPONumber()
receiver.RequestPartNumber()
receiver.RequestLotNumber()
receiver.RequestQuantity()

verifier := new Receiving.Verify(receiver)

poResults := verifier.GetResults()

recvResults := new Receiving.Results()
recvResults.display(receiver, poResults)

ExitApp

; --- Functions ----------------------------------------------------------------

