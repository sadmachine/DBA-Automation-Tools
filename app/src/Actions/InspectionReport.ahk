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
        destination := inspectionReportConfig.get("file.destinationFolder")
        FormatTime, dateOfGeneration,, ShortDate

        for n, lot in receiver.lots {
            inspectionFolder := RTrim(destination, "/\") "\" lot.inspectionNumber
            FileCreateDir, % inspectionFolder
            filename := lot.inspectionNumber " - Inspection Report.xlsx"
            filepath := #.Path.concat(inspectionFolder, filename)
            tempFilepath := #.Path.concat(A_Temp, filename)
            FileCopy, % template, % filepath
            FileCopy, % template, % tempFilepath

            #.Path.createLock(filepath)
            #.Logger.info(A_ThisFunc, "Acquired file lock")

            xlApp := ComObjCreate("Excel.Application")
            #.Logger.info(A_ThisFunc, "Created excel app")
            CurrWbk := xlApp.Workbooks.Open(tempFilepath) ; Open the master file
            #.Logger.info(A_ThisFunc, "Opened workbook")
            CurrSht := CurrWbk.Sheets(1)

            excelColumns := inspectionReportConfig.get("excelColumnMapping")

            CurrSht.range[excelColumns.get("inspectionFormNumber")].Value := lot.inspectionNumber
            CurrSht.range[excelColumns.get("reportDate")].Value := dateOfGeneration
            CurrSht.range[excelColumns.get("stelrayMaterialNumber")].Value := receiver.partNumber
            CurrSht.range[excelColumns.get("materialDescription")].Value := receiver.partDescription
            CurrSht.range[excelColumns.get("lotNumber")].Value := lot.lotNumber
            CurrSht.range[excelColumns.get("poNumber")].Value := receiver.poNumber
            CurrSht.range[excelColumns.get("vendorName")].Value := receiver.supplier
            CurrSht.range[excelColumns.get("quantityOnPo")].Value := receiver.lineQuantity
            CurrSht.range[excelColumns.get("quantityReceived")].Value := lot.quantity

            CurrWbk.Save()
            #.Logger.info(A_ThisFunc, "Saved Workbook")

            xlApp.Quit()
            #.Logger.info(A_ThisFunc, "Quit Excel App")
            xlApp := "", CurrWbk := "", CurrSht := ""

            #.Logger.info(A_ThisFunc, "Moving tempfile to real location...", {tempFilePath: tempFilePath, filePath: filePath})
            FileMove, % tempFilePath, % filePath, 1
            #.Logger.info(A_ThisFunc, "Success")

            if (ErrorLevel) {
                throw new @.FilesystemException(A_ThisFunc, "Could not copy Inspection Report from the temp directory to its destination.")
            }

            #.Path.freeLock(filepath)
            #.Logger.info(A_ThisFunc, "Released file lock")

            this.progressGui.Increment()
        }

        this.progressGui.Destroy()
    }
}