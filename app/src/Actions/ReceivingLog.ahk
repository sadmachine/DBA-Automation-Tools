; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Actions.ReceivingLog
class ReceivingLog extends Actions.Base
{
    __New(ByRef receiver)
    {
        receivingLogConfig := Config.load("receiving.incomingInspectionLog")
        fileDestination := receivingLogConfig.get("file.destination")
        templateFile := receivingLogConfig.get("file.template")
        filePath := RTrim(fileDestination, "/\") "\Receiving Log.xlsx"

        if (!FileExist(fileDestination) == "D") {
            throw new @.FilesystemException(A_ThisFunc, "The destination location for the Receiving Log file could not be accessed or does not exist. Please update 'Receiving.Incoming Inspection Log.File.Destination' to be a valid directory.")
        }

        if (!FileExist(filePath)) {
            if (!FileExist(templateFile)) {
                throw new @.FilesystemException(A_ThisFunc, "The template file for the Receiving Log either could not be accessed or does not exist. Please update 'Receiving.Incoming Inspection Log.File.Template' to be a valid .xlsx file.")
            }
            FileCopy, % templateFile, % filePath
        }

        #.Path.createLock(filepath)

        Process, Exist, EXCEL.EXE
        while(ErrorLevel)
        {
            xlApp := ComObjActive("Excel.Application")
            For Book in XL.Workbooks {
                Book.Close(1)
            }
            xlApp.Quit(), xlApp := ""
            Process, Exist, EXCEL.EXE
        }
        xlApp := ComObjCreate("Excel.Application")
        CurrWbk := xlApp.Workbooks.Open(filepath) ; Open the master file
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
        }

        CurrWbk.Save()
        xlApp.Quit()

        #.Path.freeLock(filepath)
    }
}