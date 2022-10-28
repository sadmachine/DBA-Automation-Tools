class InspectionReport
{
    __New(receiver)
    {
        Global
        CreatingReports := new UI.Base("Creating Inspection Reports", "-SysMenu +AlwaysOnTop")
        CreatingReports.ApplyFont()
        CreatingReports.Add("Text", "Center", "Creating inspection reports, please wait")
        CreatingReports.Show()
        this.receiver := receiver
        inspectionConfig := new IniConfig("inspection_report")
        if (!inspectionConfig.exists()) {
            inspectionConfig.copyFrom("inspection_report.default.ini")
        }
        template := inspectionConfig.get("file.template")
        fields := inspectionConfig.getSection("fields")
        destination := inspectionConfig.get("file.destination")

        for n, lotNumber in this.receiver.lotNumbers {
            inspection_number := (inspectionConfig.get("file.last_num") + 1)
            inspectionConfig.set("file.last_num", inspection_number)
            filepath := RTrim(destination, "/") "/" inspection_number ".xlsx"
            FileCopy, % template, % filepath

            iReport := new Excel(this.getFullPath(filepath))

            iReport.range["C2"].Value := inspection_number
            iReport.range["C4"].Value := this.receiver.partNumber
            iReport.range["C5"].Value := this.receiver.partDescription
            iReport.range["C6"].Value := lotNumber
            iReport.range["H3"].Value := this.receiver.poNumber
            iReport.range["H4"].Value := this.receiver.supplier
            iReport.range["C10"].Value := this.receiver.lineQuantity
            iReport.range["H10"].Value := this.receiver.quantities[n]

            iReport.Save()
            iReport.Quit()
        }
        CreatingReports.Destroy()
    }

    getFullPath(path)
    {
        cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
        VarSetCapacity(buf, cc*(A_IsUnicode?2:1))
        DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
        return buf
    }

}