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
; === TO-DOs ===================================================================
; TODO - Decouple from Receiver model
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Actions.ReceivingLog
class ReceivingLog extends Actions.Base
{
    __New(ByRef receiver)
    {
        receivingLogConfig := Config.load("receiving.incomingInspectionLog")
        fileDestination := receivingLogConfig.get("file.destination")
        templateFile := receivingLogConfig.get("file.template")
        copyPath := #.Path.concat(fileDestination, "Incoming Inspection Log.xlsx")
        filePath := #.Path.concat(fileDestination, ".Incoming Inspection Log.xlsx")
        tempPath := new #.Path.Temp("DBA AutoTools")
        tempFilePath := tempPath.concat(".Incoming Inspection Log.xlsx")

        this.progressGui := new UI.ProgressBoxObj("Updating Incoming Inspection Log, please wait...", "Updating Incoming Inspection Log")
        this.progressGui.SetRange(0, receiver.lots.count())
        this.progressGui.SetStartValue(0)
        this.progressGui.Show()

        #.log("app").info(A_ThisFunc, "Incoming Inspection Log Path: " filePath)

        if (!FileExist(fileDestination) == "D") {
            throw new @.FilesystemException(A_ThisFunc, "The destination location for the Receiving Log file could not be accessed or does not exist. Please update 'Receiving.Incoming Inspection Log.File.Destination' to be a valid directory.")
        }

        if (!FileExist(filePath)) {
            if (!FileExist(templateFile)) {
                throw new @.FilesystemException(A_ThisFunc, "The template file for the Receiving Log either could not be accessed or does not exist. Please update 'Receiving.Incoming Inspection Log.File.Template' to be a valid .xlsx file.")
            }
            #.Cmd.copy(templateFile, filePath)
        }

        FileGetAttrib, fileAttributes, % filePath
        if (!InStr(fileAttributes, "H")) {
            FileSetAttrib, +H, % filePath
        }

        #.Path.createLock(filePath)
        #.log("app").info(A_ThisFunc, "Acquired file lock")

        #.log("app").info(A_ThisFunc, "Copying Incoming Inspection... ", {filepath: filePath, tempFilePath: tempFilePath})
        #.Cmd.copy(filePath, tempFilePath)
        #.log("app").info(A_ThisFunc, "Success")

        if (ErrorLevel) {
            throw new @.FilesystemException(A_ThisFunc, "Could not copy '" filePath "' to '" tempFilePath "'")
        }

        ; Process, Exist, EXCEL.EXE
        ; while(ErrorLevel)
        ; {
        ;     xlApp := ComObjActive("Excel.Application")
        ;     For Book in XL.Workbooks {
        ;         Book.Close(1)
        ;     }
        ;     xlApp.Quit(), xlApp := ""
        ;     Process, Exist, EXCEL.EXE
        ; }
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
        #.log("app").info(A_ThisFunc, "Created excel app")
        xlWorkbooks := xlApp.Workbooks
        xlWorkbook := xlWorkbooks.Open(tempFilePath) ; Open the master file
        #.log("app").info(A_ThisFunc, "Opened workbook")
        xlSheet := xlWorkbook.Sheets(1)
        ; Get the last cell in column A, then save a reference to the cell next to it (column B)

        lastRowCells := xlSheet.Cells(xlApp.Rows.Count, 1)
        lastRowEnd := lastRowCells.End(xlUp := -4162)
        lastRow := lastRowEnd.Rows(1)
        emptyRowOffset := lastRow.Offset(1, 0)
        emptyRow := emptyRowOffset.Rows(1)
        FormatTime, datestr,, % "MM/dd/yyyy"

        for n, lot in receiver.lots
        {
            if (lastRow.Row != 2) {
                lastRow.Copy()
                emptyRow.PasteSpecial(xlPasteFormats := -4122)
            }

            excelColumns := receivingLogConfig.get("excelColumnMapping")

            emptyRowRange := emptyRow.Range(excelColumns.get("date") "1")
            emptyRowRange.Value := datestr
            emptyRowRange := ""

            emptyRowRange := emptyRow.Range(excelColumns.get("stelrayItemNumber") "1")
            emptyRowRange.Value := receiver.partNumber
            emptyRowRange := ""

            emptyRowRange := emptyRow.Range(excelColumns.get("materialDescription") "1")
            emptyRowRange.Value := receiver.partDescription
            emptyRowRange := ""

            emptyRowRange := emptyRow.Range(excelColumns.get("materialLotNumber") "1")
            emptyRowRange.Value := lot.lotNumber
            emptyRowRange := ""

            emptyRowRange := emptyRow.Range(excelColumns.get("lotQuantity") "1")
            emptyRowRange.Value := lot.quantity
            emptyRowRange := ""

            emptyRowRange := emptyRow.Range(excelColumns.get("poNumber") "1")
            emptyRowRange.Value := receiver.poNumber
            emptyRowRange := ""

            emptyRowRange := emptyRow.Range(excelColumns.get("inspectionNumber") "1")
            emptyRowRange.Value := lot.inspectionNumber
            emptyRowRange := ""

            emptyRowRange := emptyRow.Range(excelColumns.get("cOfCReceived") "1")
            emptyRowRange.Value := (lot.hasCert == "Yes" ? "Y" : "N")
            emptyRowRange := ""
            ;emptyRow.Range(excelColumns.get("receiverId") "1").Value := receiver.identification

            lastRow := ""
            lastRow := emptyRow

            emptyRow := ""
            emptyRowOffset := ""
            emptyRowOffset := lastRow.Offset(1, 0)
            emptyRow := emptyRowOffset.Rows(1)
            #.log("app").info(A_ThisFunc, "Added line for inspection number: " lot.inspectionNumber)
            this.progressGui.Increment()
        }

        #.log("app").info(A_ThisFunc, "Finished Loop")

        xlWorkbook.Save()
        #.log("app").info(A_ThisFunc, "Saved Workbook")

        xlApp.Quit()
        #.log("app").info(A_ThisFunc, "Quit Excel App")
        emptyRow := ""
        emptyRowOffset := ""
        lastRow := ""
        lastRowEnd := ""
        lastRowCells := ""
        xlSheet := ""
        xlWorkBook := ""
        xlWorkbooks := ""
        xlApp := ""

        #.log("app").info(A_ThisFunc, "Moving tempfile to real location...", {tempFilePath: tempFilePath, filePath: filePath})
        #.Cmd.move(tempFilePath, filePath)
        #.log("app").info(A_ThisFunc, "Success")

        if (ErrorLevel) {
            throw new @.FilesystemException(A_ThisFunc, "Could not copy incoming inspection log from the temp directory to its destination.")
        }

        if (!#.Path.inUse(copyPath)) {
            #.Cmd.copy(filePath, copyPath)
            FileSetAttrib, -H, % copyPath
            FileSetAttrib, +H, % filePath
        }

        #.Path.freeLock(filePath)
        #.log("app").info(A_ThisFunc, "Released file lock")

        this.progressGui.Destroy()
    }
}