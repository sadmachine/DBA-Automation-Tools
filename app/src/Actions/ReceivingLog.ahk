; === Script Information =======================================================
; Name .........: Receiving Log Action
; Description ..: Appends a new line to the receiving log
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: ReceivingLog.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; Revision 2 (02/27/2023)
; * Write to temporary excel file on local maachine, then copy to real location
;
; Revision 3 (02/28/2023)
; * Use #.Path.Temp for temporary files
;
; Revision 4 (03/05/2023)
; * Implement CMD copy/move
;
; Revision 5 (04/06/2023)
; * Update to run as a queue job
; * Tested locally, appears to be working
;
; === TO-DOs ===================================================================
; TODO - Decouple from Receiver model
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Actions.ReceivingLog
class ReceivingLog extends Actions.Base
{
    __New(receiver, lotIndex)
    {
        this.receiver := receiver
        this.lotIndex := lotIndex
    }

    create()
    {
        FormatTime, dateStr,, % "MM/dd/yyyy"
        lot := this.receiver.lots[this.lotIndex]

        this.data["data"] := {}
        this.data["data"]["date"] := dateStr
        this.data["data"]["stelrayItemNumber"] := this.receiver.partNumber
        this.data["data"]["materialDescription"] := this.receiver.partDescription
        this.data["data"]["materialLotNumber"] := lot.lotNumber
        this.data["data"]["lotQuantity"] := lot.quantity
        this.data["data"]["poNumber"] := this.receiver.poNumber
        this.data["data"]["inspectionNumber"] := lot.inspectionNumber
        this.data["data"]["cOfCReceived"] := lot.hasCert

        return this.data
    }

    execute()
    {
        receivingLogConfig := Config.load("receiving.incomingInspectionLog")
        fileDestination := receivingLogConfig.get("file.destination")
        templateFile := receivingLogConfig.get("file.template")
        filePath := #.Path.concat(fileDestination, "Incoming Inspection Log.xlsx")
        tempPath := new #.Path.Temp("DBA AutoTools")
        tempFilePath := tempPath.concat("Incoming Inspection Log.xlsx")

        reportData := this.data["data"]

        #.log("queue").info(A_ThisFunc, "Incoming Inspection Log Path: " filePath)

        if (!FileExist(fileDestination) == "D") {
            throw new @.FilesystemException(A_ThisFunc, "The destination location for the Receiving Log file could not be accessed or does not exist. Please update 'Receiving.Incoming Inspection Log.File.Destination' to be a valid directory.")
        }

        if (!FileExist(filePath)) {
            if (!FileExist(templateFile)) {
                throw new @.FilesystemException(A_ThisFunc, "The template file for the Receiving Log either could not be accessed or does not exist. Please update 'Receiving.Incoming Inspection Log.File.Template' to be a valid .xlsx file.")
            }
            #.Cmd.copy(templateFile, filePath)
        }

        if (#.Path.inUse(filePath)) {
            throw new @.FilesystemException(A_ThisFunc, "The filepath is currently in use", {filepath: filepath})
        }
        #.Path.createLock(filePath)
        #.log("queue").info(A_ThisFunc, "Acquired file lock")

        #.log("queue").info(A_ThisFunc, "Copying Incoming Inspection... ", {filepath: filePath, tempFilePath: tempFilePath})
        #.Cmd.copy(filePath, tempFilePath)
        #.log("queue").info(A_ThisFunc, "Success")

        if (ErrorLevel) {
            throw new @.FilesystemException(A_ThisFunc, "Could not copy '" filePath "' to '" tempFilePath "'")
        }

        xlApp := ""
        xlWorkbooks := ""
        xlWorkBook := ""
        xlSheet := ""
        lastRowCells := ""
        lastRowEnd := ""
        lastRow := ""
        emptyRowOffset := ""
        emptyRow := ""
        xlApp := ComObjCreate("Excel.Application")
        #.log("queue").info(A_ThisFunc, "Created excel app")
        xlWorkbooks := xlApp.Workbooks
        xlWorkbook := xlWorkbooks.Open(tempFilePath) ; Open the master file
        #.log("queue").info(A_ThisFunc, "Opened workbook")
        xlSheet := xlWorkbook.Sheets(1)
        ; Get the last cell in column A, then save a reference to the cell next to it (column B)

        lastRowCells := xlSheet.Cells(xlApp.Rows.Count, 1)
        lastRowEnd := lastRowCells.End(xlUp := -4162)
        lastRow := lastRowEnd.Rows(1)
        emptyRowOffset := lastRow.Offset(1, 0)
        emptyRow := emptyRowOffset.Rows(1)
        FormatTime, datestr,, % "MM/dd/yyyy"

        if (lastRow.Row != 2) {
            lastRow.Copy()
            emptyRow.PasteSpecial(xlPasteFormats := -4122)
        }

        excelColumns := receivingLogConfig.get("excelColumnMapping")

        for key, value in reportData {
            emptyRowRange := emptyRow.Range(excelColumns.get(key) "1")
            emptyRowRange.Value := value
            emptyRowRange := ""
        }

        #.log("queue").info(A_ThisFunc, "Added line for inspection number: " lot.inspectionNumber)

        xlWorkbook.Save()
        #.log("queue").info(A_ThisFunc, "Saved Workbook")

        xlApp.Quit()
        #.log("queue").info(A_ThisFunc, "Quit Excel App")
        emptyRow := ""
        emptyRowOffset := ""
        lastRow := ""
        lastRowEnd := ""
        lastRowCells := ""
        xlSheet := ""
        xlWorkBook := ""
        xlWorkbooks := ""
        xlApp := ""

        #.log("queue").info(A_ThisFunc, "Moving tempfile to real location...", {tempFilePath: tempFilePath, filePath: filePath})
        #.Cmd.move(tempFilePath, filePath)
        #.log("queue").info(A_ThisFunc, "Success")

        if (ErrorLevel) {
            throw new @.FilesystemException(A_ThisFunc, "Could not copy incoming inspection log from the temp directory to its destination.")
        }

        #.Path.freeLock(filePath)
        #.log("queue").info(A_ThisFunc, "Released file lock")

        return true
    }
}