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
        tempFilePath := #.Path.concat(A_Temp, ".Incoming Inspection Log.xlsx")

        #.Logger.info(A_ThisFunc, "Incoming Inspection Log Path: " filePath)

        if (!FileExist(fileDestination) == "D") {
            throw new @.FilesystemException(A_ThisFunc, "The destination location for the Receiving Log file could not be accessed or does not exist. Please update 'Receiving.Incoming Inspection Log.File.Destination' to be a valid directory.")
        }

        if (!FileExist(filePath)) {
            if (!FileExist(templateFile)) {
                throw new @.FilesystemException(A_ThisFunc, "The template file for the Receiving Log either could not be accessed or does not exist. Please update 'Receiving.Incoming Inspection Log.File.Template' to be a valid .xlsx file.")
            }
            FileCopy, % templateFile, % filePath
        }

        FileGetAttrib, fileAttributes, % filePath
        if (!InStr(fileAttributes, "H")) {
            FileSetAttrib, +H, % filePath
        }

        #.Path.createLock(filePath)
        #.Logger.info(A_ThisFunc, "Acquired file lock")

        #.Logger.info(A_ThisFunc, "Copying Incoming Inspection... ", {filepath: filePath, tempFilePath: tempFilePath})
        FileCopy, % filePath, % tempFilePath, 1
        #.Logger.info(A_ThisFunc, "Success")

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
        xlApp := ComObjCreate("Excel.Application")
        #.Logger.info(A_ThisFunc, "Created excel app")
        CurrWbk := xlApp.Workbooks.Open(tempFilePath) ; Open the master file
        #.Logger.info(A_ThisFunc, "Opened workbook")
        CurrSht := CurrWbk.Sheets(1)
        ; Get the last cell in column A, then save a reference to the cell next to it (column B)
        lastRow := CurrSht.Cells(xlApp.Rows.Count, 1).End(xlUp := -4162).Rows(1)
        emptyRow := lastRow.Offset(1, 0).Rows(1)
        FormatTime, datestr,, % "MM/dd/yyyy"

        for n, lot in receiver.lots
        {
            if (lastRow.Row != 2) {
                lastRow.Copy()
                emptyRow.PasteSpecial(xlPasteFormats := -4122)
            }

            excelColumns := receivingLogConfig.get("excelColumnMapping")
            emptyRow.Range(excelColumns.get("date") "1").Value := datestr
            emptyRow.Range(excelColumns.get("stelrayItemNumber") "1").Value := receiver.partNumber
            emptyRow.Range(excelColumns.get("materialDescription") "1").Value := receiver.partDescription
            emptyRow.Range(excelColumns.get("materialLotNumber") "1").Value := lot.lotNumber
            emptyRow.Range(excelColumns.get("lotQuantity") "1").Value := lot.quantity
            emptyRow.Range(excelColumns.get("poNumber") "1").Value := receiver.poNumber
            emptyRow.Range(excelColumns.get("inspectionNumber") "1").Value := lot.inspectionNumber
            emptyRow.Range(excelColumns.get("cOfCReceived") "1").Value := (lot.hasCert == "Yes" ? "Y" : "N")
            ;emptyRow.Range(excelColumns.get("receiverId") "1").Value := receiver.identification

            lastRow := emptyRow
            emptyRow := lastRow.Offset(1, 0).Rows(1)
            #.Logger.info(A_ThisFunc, "Added line for inspection number: " lot.inspectionNumber)
        }

        #.Logger.info(A_ThisFunc, "Finished Loop")

        CurrWbk.Save()
        #.Logger.info(A_ThisFunc, "Saved Workbook")

        xlApp.Quit()
        #.Logger.info(A_ThisFunc, "Quit Excel App")

        xlApp := "", CurrWbk := "", CurrSht := ""

        #.Logger.info(A_ThisFunc, "Moving tempfile to real location...", {tempFilePath: tempFilePath, filePath: filePath})
        FileMove, % tempFilePath, % filePath, 1
        #.Logger.info(A_ThisFunc, "Success")

        if (ErrorLevel) {
            throw new @.FilesystemException(A_ThisFunc, "Could not copy incoming inspection log from the temp directory to its destination.")
        }

        if (!#.Path.inUse(copyPath)) {
            FileCopy, % filePath, % copyPath, 1
            FileSetAttrib, -H, % copyPath
            FileSetAttrib, +H, % filePath
        }

        #.Path.freeLock(filePath)
        #.Logger.info(A_ThisFunc, "Released file lock")
    }
}