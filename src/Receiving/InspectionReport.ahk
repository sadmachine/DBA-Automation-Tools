class InspectionReport
{
    __New(receiver)
    {
        Global
        this.receiver := receiver
        this.reportCount := this.receiver.lotNumbers.Count()

        this.buildGui()

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

            this.updateGui(A_Index)
        }

        this.destroyGui()
    }

    getFullPath(path)
    {
        cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
        VarSetCapacity(buf, cc*(A_IsUnicode?2:1))
        DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
        return buf
    }

    buildGui()
    {
        this.CreatingReports := new UI.Base("Creating Inspection Reports", "-SysMenu +AlwaysOnTop")
        this.CreatingReports.ApplyFont()
        this.CreatingReports.Add("Text", "Center w200 r2", "Creating inspection reports, please wait")
        this.ProgressBar := this.CreatingReports.Add("Progress", "w200 h20 backgroundSilver cLime range0-" this.reportCount, 1)
        this.ProgressText := this.CreatingReports.Add("Text", "Center w200 r1", "1 / " this.reportCount)
        this.CreatingReports.Show()
    }

    updateGui(currentCount)
    {
        progressBar := this.ProgressBar
        progressText := this.ProgressText
        GuiControl,, % %progressBar%, % currentCount+1
        GuiControl,, % %progressText%, % currentCount+1 " / " this.reportCount
    }

    destroyGui()
    {
        this.CreatingReports.Destroy()
    }

}