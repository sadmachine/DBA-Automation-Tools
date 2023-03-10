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
; Revision 2 (02/27/2023)
; * Write to temporary excel file on local machine, then copy to real location
;
; Revision 3 (03/05/2023)
; * Add progress gui, implement CMD copy/move
;
; === TO-DOs ===================================================================
; TODO - Decouple from Receiver model
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Actions.InspectionReport
class InspectionReport extends Actions.Base
{
    /*
        @var string partNumber
        @var string partDescription
        @var string poNumber
        @var string supplier
        @var string lineQuantity
        @var LotInfo[] lots
    */
    __New(ByRef receiver)
    {
        Global

        queueDir := #.Path.concat(PROJECT_ROOT, "queue")
        FormatTime, dateOfGeneration,, ShortDate

        for n, lot in receiver.lots {
            inspectionFolder := RTrim(destination, "/\") "\" lot.inspectionNumber
            FileCreateDir, % inspectionFolder
            filename := lot.inspectionNumber " - Inspection Report.xlsx"
            filepath := #.Path.concat(inspectionFolder, filename)
            tempFilepath := tempDir.concat(filename)
            #.Cmd.copy(template, filepath)
            #.Cmd.copy(template, tempFilepath)

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
            #.Cmd.move(tempFilePath, filePath)
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

    watch(directory)
    {
        pollMethod := ObjBindMethod(Actions.InspectionReport, "poll")
        pollMethod.Bind(directory)
        SetTimer, % pollMethod, % base.pollPeriod
    }

    poll(directory)
    {
        this.reportCount := receiver.lots.Count()

        queueDir := #.Path.concat(PROJECT_ROOT, "queue")

        inspectionReportConfig := Config.load("receiving.inspectionReport")
        template := inspectionReportConfig.get("file.template")
        destination := inspectionReportConfig.get("file.destinationFolder")
        tempDir := new #.Path.Temp("DBA AutoTools")
        FormatTime, dateOfGeneration,, ShortDate

        for n, lot in receiver.lots {
            inspectionFolder := RTrim(destination, "/\") "\" lot.inspectionNumber
            FileCreateDir, % inspectionFolder
            filename := lot.inspectionNumber " - Inspection Report.xlsx"
            filepath := #.Path.concat(inspectionFolder, filename)
            tempFilepath := tempDir.concat(filename)
            #.Cmd.copy(template, filepath)
            #.Cmd.copy(template, tempFilepath)

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
            #.Cmd.move(tempFilePath, filePath)
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