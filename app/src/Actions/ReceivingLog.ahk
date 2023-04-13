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
; * Use Lib.Path.Temp for temporary files
;
; Revision 4 (03/05/2023)
; * Implement CMD copy/move
;
; Revision 5 (04/06/2023)
; * Update to run as a queue job
; * Tested locally, appears to be working
;
; Revision 6 (04/08/2023)
; * Add receiver ID to output
;
; Revision 7 (04/13/2023)
; * Edit files directly, instead of using tempfiles
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
        dateStr := FormatTime(, "MM/dd/yyyy")
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
        this.data["data"]["receiverId"] := this.receiver.identification

        return this.data
    }

    execute()
    {
        receivingLogConfig := Config.load("receiving.incomingInspectionLog")
        fileDestination := receivingLogConfig.get("file.destination")
        templateFile := receivingLogConfig.get("file.template")
        filePath := Lib.Path.concat(fileDestination, "Incoming Inspection Log.xlsx")
        reportData := this.data["data"]

        this._prepareFile(fileDestination, filePath, templateFile)

        try {
            Lib.Path.createLock(filePath)
            Lib.log("queue").info(A_ThisFunc, "Acquired file lock")

            xlApp := ""
            xlWorkbooks := ""
            xlWorkBook := ""
            xlSheet := ""
            lastRowCells := ""
            lastRowEnd := ""
            lastRow := ""
            emptyRowOffset := ""
            emptyRow := ""
            xlApp := ComObject("Excel.Application")
            Lib.log("queue").info(A_ThisFunc, "Created excel app")
            xlWorkbooks := xlApp.Workbooks
            xlWorkbook := xlWorkbooks.Open(filePath) ; Open the master file
            Lib.log("queue").info(A_ThisFunc, "Opened workbook")
            xlSheet := xlWorkbook.Sheets(1)
            ; Get the last cell in column A, then save a reference to the cell next to it (column B)

            lastRowCells := xlSheet.Cells(xlApp.Rows.Count, 1)
            lastRowEnd := lastRowCells.End(xlUp := -4162)
            lastRow := lastRowEnd.Rows(1)
            emptyRowOffset := lastRow.Offset(1, 0)
            emptyRow := emptyRowOffset.Rows(1)
            datestr := FormatTime(, "MM/dd/yyyy")

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

            Lib.log("queue").info(A_ThisFunc, "Added line for inspection number: " lot.inspectionNumber)

            xlWorkbook.Save()
            Lib.log("queue").info(A_ThisFunc, "Saved Workbook")

            xlApp.Quit()
            Lib.log("queue").info(A_ThisFunc, "Quit Excel App")
            emptyRow := ""
            emptyRowOffset := ""
            lastRow := ""
            lastRowEnd := ""
            lastRowCells := ""
            xlSheet := ""
            xlWorkBook := ""
            xlWorkbooks := ""
            xlApp := ""

            Lib.Path.freeLock(filePath)
            Lib.log("queue").info(A_ThisFunc, "Released file lock")
        } catch Any as e {
            Lib.Path.freeLock(filePath)
            Lib.log("queue").info(A_ThisFunc, "Released file lock")
            throw e
        }

        return true
    }

    _prepareFile(fileDestination, filePath, templateFile)
    {
        if (!FileExist(fileDestination) == "D") {
            throw new Core.FilesystemException(A_ThisFunc, "The destination location for the Receiving Log file could not be accessed or does not exist. Please update 'Receiving.Incoming Inspection Log.File.Destination' to be a valid directory.")
        }

        if (!FileExist(filePath)) {
            if (!FileExist(templateFile)) {
                throw new Core.FilesystemException(A_ThisFunc, "The template file for the Receiving Log either could not be accessed or does not exist. Please update 'Receiving.Incoming Inspection Log.File.Template' to be a valid .xlsx file.")
            }
            Lib.Cmd.copy(templateFile, filePath)
        }

        if (Lib.Path.inUse(filePath)) {
            throw new Core.FileInUseException(A_ThisFunc, "The filepath is currently in use", {filepath: filepath})
        }
    }
}