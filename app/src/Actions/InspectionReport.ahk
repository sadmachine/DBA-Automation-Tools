; === Script Information =======================================================
; Name .........: Inspection Report Action
; Description ..: Generates Inspection Reports from a given receiver model
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: InspectionReport.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; TODO - Decouple from Receiver model
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
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
        destination := inspectionReportConfig.get("file.destinationFolder")
        FormatTime, dateOfGeneration,, ShortDate

        for n, lot in receiver.lots {
            inspectionFolder := RTrim(destination, "/\") "\" lot.inspectionNumber
            FileCreateDir, % inspectionFolder
            filepath := inspectionFolder "\" lot.inspectionNumber " - Inspection Report.xlsx"
            FileCopy, % template, % filepath

            iReport := new Excel(#.Path.makeAbsolute(filepath))

            excelColumns := inspectionReportConfig.get("excelColumnMapping")

            iReport.range[excelColumns.get("inspectionFormNumber")].Value := lot.inspectionNumber
            iReport.range[excelColumns.get("reportDate")].Value := dateOfGeneration
            iReport.range[excelColumns.get("stelrayMaterialNumber")].Value := receiver.partNumber
            iReport.range[excelColumns.get("materialDescription")].Value := receiver.partDescription
            iReport.range[excelColumns.get("lotNumber")].Value := lot.lotNumber
            iReport.range[excelColumns.get("poNumber")].Value := receiver.poNumber
            iReport.range[excelColumns.get("vendorName")].Value := receiver.supplier
            iReport.range[excelColumns.get("quantityOnPo")].Value := receiver.lineQuantity
            iReport.range[excelColumns.get("quantityReceived")].Value := lot.quantity

            iReport.Save()
            iReport.Quit()

            this.progressGui.Increment()
        }

        this.progressGui.Destroy()
    }
}