class InspectionReport
{
    __New(receiver)
    {
        Global
        this.receiver := receiver
        this.reportCount := this.receiver.lotNumbers.Count()

        this.progressGui := new UI.ProgressBoxObj("Creating Inspection Reports, please wait...", "Creating Inspection Reports")
        this.progressGui.SetRange(0, this.reportCount)
        this.progressGui.SetStartValue(1)
        this.progressGui.Show()

        inspectionConfig := new IniConfig("inspection_report")
        if (!inspectionConfig.exists()) {
            inspectionConfig.copyFrom("inspection_report.default.ini")
        }
        template := inspectionConfig.get("file.template")
        fields := inspectionConfig.getSection("fields")
        destination := inspectionConfig.get("file.destination")
        FormatTime, dateOfGeneration,, ShortDate

        for n, lotNumber in this.receiver.lotNumbers {
            inspectionNumber := (inspectionConfig.get("file.last_num") + 1)
            inspectionConfig.set("file.last_num", inspectionNumber)
            filepath := RTrim(destination, "/") "/" inspectionNumber ".xlsx"
            FileCopy, % template, % filepath

            iReport := new Excel(this.getFullPath(filepath))

            iReport.range["C2"].Value := inspectionNumber
            iReport.range["C3"].Value := dateOfGeneration
            iReport.range["C4"].Value := this.receiver.partNumber
            iReport.range["C5"].Value := this.receiver.partDescription
            iReport.range["C6"].Value := lotNumber
            iReport.range["H3"].Value := this.receiver.poNumber
            iReport.range["H4"].Value := this.receiver.supplier
            iReport.range["C10"].Value := this.receiver.lineQuantity
            iReport.range["H10"].Value := this.receiver.quantities[n]

            iReport.Save()
            iReport.Quit()

            this.progressGui.Increment()
        }

        this.progressGui.Destroy()
    }

    getFullPath(path)
    {
        cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
        VarSetCapacity(buf, cc*(A_IsUnicode?2:1))
        DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
        return buf
    }
}