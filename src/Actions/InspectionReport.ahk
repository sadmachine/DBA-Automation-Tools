; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Actions.InspectionReport
class InspectionReport extends Actions.Base
{
    __New(ByRef receiver)
    {
        Global
        this.reportCount := receiver.lots.Count()

        this.progressGui := new UI.ProgressBoxObj("Creating Inspection Reports, please wait...", "Creating Inspection Reports")
        this.progressGui.SetRange(0, this.reportCount)
        this.progressGui.SetStartValue(1)
        this.progressGui.Show()

        inspectionReportConfig := Config.load("receiving.inspectionReport")
        template := inspectionReportConfig.get("file.template")
        destination := inspectionReportConfig.get("file.destination")
        inspectionFolder := RTrim(destination, "/") "/" inspectionNumber
        FormatTime, dateOfGeneration,, ShortDate

        for n, lot in receiver.lots {
            FileCreateDir, % inspectionFolder
            filepath := inspectionFolder "/" inspectionNumber " - Inspection Report.xlsx"
            FileCopy, % template, % filepath

            iReport := new Excel(@File.getFullPath(filepath))

            iReport.range[inspectionReportConfig.get("excelColumnMapping.inspectionFormNumber")].Value := lot.inspectionNumber
            iReport.range[inspectionReportconfig.get("excelColumnMapping.reportDate")].Value := dateOfGeneration
            iReport.range[inspectionReportConfig.get("excelColumnMapping.stelrayMaterialNumber")].Value := receiver.partNumber
            iReport.range[inspectionReportConfig.get("excelColumnMapping.materialDescription")].Value := receiver.partDescription
            iReport.range[inspectionReportConfig.get("excelColumnMapping.lotNumber")].Value := lot.lotNumber
            iReport.range[inspectionReportConfig.get("excelColumnMapping.poNumber")].Value := receiver.poNumber
            iReport.range[inpsectionReportConfig.get("excelColumnMapping.vendorName")].Value := receiver.supplier
            iReport.range[inspectionReportConfig.get("excelColumnMapping.quantityOnPo")].Value := receiver.lineQuantity
            iReport.range[inpsectionReportConfig.get("excelColumnMapping.quantityReceived")].Value := lot.quantity

            iReport.Save()
            iReport.Quit()

            this.progressGui.Increment()
        }

        this.progressGui.Destroy()
    }
}