; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Actions.ReceivingLog
class ReceivingLog extends Actions.Base
{
    __New(ByRef receiver)
    {
        receivingLogConfig := Config.load("receiving.log")
        filepath := receivingLogConfig.get("file.location")
        exists := FileExist(filepath)
        if (!exists) {
            throw new @.FilesystemException(A_ThisFunc, "Receiving log file does not exist at path: '" filepath "'. Please update the Receiving Log location to point to an existing file.")
        }

        @File.createLock(filepath)

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

            lastRow := emptyRow
            emptyRow := lastRow.Offset(1, 0).Rows(1)
        }

        CurrWbk.Save()
        xlApp.Quit()

        @File.freeLock(filepath)
    }
}