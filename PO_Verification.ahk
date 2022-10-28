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

results := new Receiving.Results()
results.display(receiver, poResults)

ExitApp

; --- Functions ----------------------------------------------------------------

CreateNewInspectionReport(part_number, lot_number, part_description, po_number, vendor_name, quantity, quantity_received)
{
    inspectionConfig := new IniConfig("inspection_report")
    if (!inspectionConfig.exists()) {
        inspectionConfig.copyFrom("inspection_report.default.ini")
    }
    template := inspectionConfig.get("file.template")
    fields := inspectionConfig.getSection("fields")
    destination := inspectionConfig.get("file.destination")
    inspection_number := (inspectionConfig.get("file.last_num") + 1)
    inspectionConfig.set("file.last_num", inspection_number)
    filepath := RTrim(destination, "/") "/" inspection_number ".xlsx"
    MsgBox % template " " filepath
    FileCopy, % template, % filepath

    iReport := new Excel(File.getFullPath(filepath), true)

    iReport.range["C2"].Value := inspection_number
    iReport.range["C4"].Value := part_number
    iReport.range["C5"].Value := part_description
    iReport.range["C6"].Value := lot_number
    iReport.range["H3"].Value := po_number
    iReport.range["H4"].Value := vendor_name
    iReport.range["C10"].Value := quantity
    iReport.range["H10"].Value := quantity_received
    iReport.Save()
    iReport.Quit()

    MsgBox % "Wait"
}
