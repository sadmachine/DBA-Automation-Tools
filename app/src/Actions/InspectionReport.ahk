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
        queueDir := #.Path.concat(queueDir, "inspection-reports")
        FormatTime, dateStr,, % "yyyyMMddHHmmss"
        FormatTime, dateOfGeneration,, ShortDate
        Random, salt, 0, 100000

        for n, lot in receiver.lots {

            if (!InStr(FileExist(queueDir), "D")) {
                FileCreateDir, % queueDir
            }
            filename := dateStr "-" n "-" salt
            this.filepath := #.Path.concat(queueDir, filename)

            this.writeToJob("inspectionFormNumber", lot.inspectionNumber)
            this.writeToJob("reportDate", dateOfGeneration)
            this.writeToJob("stelrayMaterialNumber", receiver.partNumber)
            this.writeToJob("materialDescription", receiver.partDescription)
            this.writeToJob("lotNumber", lot.lotNumber)
            this.writeToJob("poNumber", receiver.poNumber)
            this.writeToJob("vendorName", receiver.supplier)
            this.writeToJob("quantityOnPo", receiver.lineQuantity)
            this.writeToJob("quantityReceived", lot.quantity)

            if (ErrorLevel) {
                throw new @.FilesystemException(A_ThisFunc, "Could not create Inspection Report queue job.")
            }
        }
    }

    writeToJob(key, value)
    {
        IniWrite, % value, % this.filepath, % "data", % key
    }

    readFromJob(filepath, key)
    {
        IniRead, output, % filepath, % "data", % key, % "__UNDEFINED__"
        return output
    }

    watch(directory)
    {
        pollMethod := ObjBindMethod(Actions.InspectionReport, "poll")
        pollMethod.Bind(directory)
        SetTimer, % pollMethod, % base.pollPeriod
    }

    poll(directory)
    {
        try {
            queueDir := #.Path.concat(PROJECT_ROOT, "queue")
            queueDir := #.Path.concat(queueDir, "inspection-reports")

            inspectionReportConfig := Config.load("receiving.inspectionReport")
            template := inspectionReportConfig.get("file.template")
            destination := inspectionReportConfig.get("file.destinationFolder")
            tempDir := new #.Path.Temp("DBA AutoTools")

            Loop, Files, % #.path.concat(queueDir, "*"), F
            {
                inspectionFolder := #.Path.concat(destination, lot.inspectionNumber)
                FileCreateDir, % inspectionFolder
                filename := lot.inspectionNumber " - Inspection Report.xlsx"
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

                queueFilepath := A_LoopFileLongPath

                CurrSht.range[excelColumns.get("inspectionFormNumber")].Value := this.readFromJob(queueFilepath, "inspectionFormNumber")
                CurrSht.range[excelColumns.get("reportDate")].Value := this.readFromJob(queueFilepath, "reportDate")
                CurrSht.range[excelColumns.get("stelrayMaterialNumber")].Value := this.readFromJob(queueFilepath, "stelrayMaterialNumber")
                CurrSht.range[excelColumns.get("materialDescription")].Value := this.readFromJob(queueFilepath, "materialDescription")
                CurrSht.range[excelColumns.get("lotNumber")].Value := this.readFromJob(queueFilepath, "lotNumber")
                CurrSht.range[excelColumns.get("poNumber")].Value := this.readFromJob(queueFilepath, "poNumber")
                CurrSht.range[excelColumns.get("vendorName")].Value := this.readFromJob(queueFilepath, "vendorName")
                CurrSht.range[excelColumns.get("quantityOnPo")].Value := this.readFromJob(queueFilepath, "quantityOnPo")
                CurrSht.range[excelColumns.get("quantityReceived")].Value := this.readFromJob(queueFilepath, "quantityReceived")

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
        } catch e {
            #.log("queue").error(A_ThisFunc, e.message, e.data)
        }
    }
}