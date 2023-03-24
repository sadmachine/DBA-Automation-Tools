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
; Revision 4 (03/15/2023)
; * Converted to creating a queued job instead of immediately creating
; * Moved some methods from here to IniFile utility class
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
    __New(receiver)
    {
        this.receiver := receiver
    }

    create()
    {
        FormatTime, dateOfGeneration,, ShortDate
        for n, lot in this.receiver.lots {
            currentData := {}
            currentData["inspectionFormNumber"] := lot.inspectionNumber
            currentData["reportDate"] := dateOfGeneration
            currentData["stelrayMaterialNumber"] := this.receiver.partNumber
            currentData["materialDescription"] := this.receiver.partDescription
            currentData["lotNumber"] := lot.lotNumber
            currentData["poNumber"] := this.receiver.poNumber
            currentData["vendorName"] := this.receiver.supplier
            currentData["quantityOnPo"] := this.receiver.lineQuantity
            currentData["quantityReceived"] := lot.quantity
            this.data[n] := currentData
        }
    }

    execute()
    {
        destination := inspectionReportConfig.get("file.destinationFolder")
        tempDir := new #.Path.Temp("DBA AutoTools")

        for n, reportData in this.data {
            inspectionNumber := reportData["inspectionFormNumber"]
            inspectionFolder := #.Path.concat(destination, inspectionNumber)
            FileCreateDir, % inspectionFolder
            filename := inspectionNumber " - Inspection Report.xlsx"
            filepath := #.Path.concat(inspectionFolder, filename)
            tempFilepath := tempDir.concat(filename)
            #.Cmd.copy(template, filepath)
            #.Cmd.copy(template, tempFilepath)

            #.Path.createLock(filepath)
            #.log("queue").info(A_ThisFunc, "Acquired file lock")

            xlApp := ComObjCreate("Excel.Application")
            #.log("queue").info(A_ThisFunc, "Created excel app")
            CurrWbk := xlApp.Workbooks.Open(tempFilepath) ; Open the master file
            #.log("queue").info(A_ThisFunc, "Opened workbook")
            CurrSht := CurrWbk.Sheets(1)

            excelColumns := inspectionReportConfig.get("excelColumnMapping")

            for columnName, value in reportData {
                CurrSht.range[excelColumns.get(columnName)].Value := reportData[columnName]
            }

            CurrWbk.Save()
            #.log("queue").info(A_ThisFunc, "Saved Workbook")

            xlApp.Quit()
            #.log("queue").info(A_ThisFunc, "Quit Excel App")
            xlApp := "", CurrWbk := "", CurrSht := ""

            #.log("queue").info(A_ThisFunc, "Moving tempfile to real location...", {tempFilePath: tempFilePath, filePath: filePath})
            #.Cmd.move(tempFilePath, filePath)
            #.log("queue").info(A_ThisFunc, "Success")

            if (ErrorLevel) {
                throw new @.FilesystemException(A_ThisFunc, "Could not copy Inspection Report from the temp directory to its destination.", {tempFilePath: tempFilePath, filePath: filePath})
            }

            #.Path.freeLock(filepath)
            #.log("queue").info(A_ThisFunc, "Released file lock")
        }
    }

    poll(directory)
    {
        queueDir := directory

        inspectionReportConfig := Config.load("receiving.inspectionReport")
        template := inspectionReportConfig.get("file.template")
        tempDir := new #.Path.Temp("DBA AutoTools")

        Loop, Files, % #.path.concat(queueDir, "*"), F
        {
            queueFilepath := A_LoopFileLongPath
            inspectionNumber := jobFile.read(queueFilepath, "inspectionFormNumber")
            inspectionFolder := #.Path.concat(destination, inspectionNumber)
            FileCreateDir, % inspectionFolder
            filename := inspectionNumber " - Inspection Report.xlsx"
            filepath := #.Path.concat(inspectionFolder, filename)
            tempFilepath := tempDir.concat(filename)
            #.Cmd.copy(template, filepath)
            #.Cmd.copy(template, tempFilepath)

            #.Path.createLock(filepath)
            #.log("queue").info(A_ThisFunc, "Acquired file lock")

            xlApp := ComObjCreate("Excel.Application")
            #.log("queue").info(A_ThisFunc, "Created excel app")
            CurrWbk := xlApp.Workbooks.Open(tempFilepath) ; Open the master file
            #.log("queue").info(A_ThisFunc, "Opened workbook")
            CurrSht := CurrWbk.Sheets(1)

            excelColumns := inspectionReportConfig.get("excelColumnMapping")

            jobFile := new #.IniFile(queueFilePath)

            CurrSht.range[excelColumns.get("inspectionFormNumber")].Value := jobFile.read("data", "inspectionFormNumber")
            CurrSht.range[excelColumns.get("reportDate")].Value := jobFile.read("data", "reportDate")
            CurrSht.range[excelColumns.get("stelrayMaterialNumber")].Value := jobFile.read("data", "stelrayMaterialNumber")
            CurrSht.range[excelColumns.get("materialDescription")].Value := jobFile.read("data", "materialDescription")
            CurrSht.range[excelColumns.get("lotNumber")].Value := jobFile.read("data", "lotNumber")
            CurrSht.range[excelColumns.get("poNumber")].Value := jobFile.read("data", "poNumber")
            CurrSht.range[excelColumns.get("vendorName")].Value := jobFile.read("data", "vendorName")
            CurrSht.range[excelColumns.get("quantityOnPo")].Value := jobFile.read("data", "quantityOnPo")
            CurrSht.range[excelColumns.get("quantityReceived")].Value := jobFile.read("data", "quantityReceived")

            CurrWbk.Save()
            #.log("queue").info(A_ThisFunc, "Saved Workbook")

            xlApp.Quit()
            #.log("queue").info(A_ThisFunc, "Quit Excel App")
            xlApp := "", CurrWbk := "", CurrSht := ""

            #.log("queue").info(A_ThisFunc, "Moving tempfile to real location...", {tempFilePath: tempFilePath, filePath: filePath})
            #.Cmd.move(tempFilePath, filePath)
            #.log("queue").info(A_ThisFunc, "Success")

            if (ErrorLevel) {
                throw new @.FilesystemException(A_ThisFunc, "Could not copy Inspection Report from the temp directory to its destination.", {tempFilePath: tempFilePath, filePath: filePath})
            }

            #.Path.freeLock(filepath)
            #.log("queue").info(A_ThisFunc, "Released file lock")
            FileDelete, % queueFilepath
        }
    }
}