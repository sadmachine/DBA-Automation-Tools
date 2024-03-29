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
; Revision 5 (03/31/2023)
; * Near finished implementing queue job interface
; * Removed legacy poll() method
;
; Revision 6 (04/06/2023)
; * Tested locally and seems to be working
;
; Revision 7 (04/12/2023)
; * Edit the file directly, instead of using tempfiles
;
; Revision 8 (05/04/2023)
; * Change how `lineQuantity` is formatted to remove unnecessary trailing 0's
;
; === TO-DOs ===================================================================
; TODO - Decouple from Receiver model
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Actions.InspectionReport
class InspectionReport extends Actions.Base
{
    static expectedDataKeys = ["inspectionFormNumber", "reportDate", "stelrayMaterialNumber", "materialDescription", "lotNumber", "poNumber", "vendorName", "quantityOnPo", "quantityReceived"]

    /*
        @var string partNumber
        @var string partDescription
        @var string poNumber
        @var string supplier
        @var string lineQuantity
        @var LotInfo[] lots
    */
    __New(receiver, lotIndex)
    {
        this.receiver := receiver
        this.lotIndex := lotIndex
    }

    create()
    {
        FormatTime, dateOfGeneration,, ShortDate
        lot := this.receiver.lots[this.lotIndex]

        lineQuantity := RTrim(this.receiver.lineQuantity, "0")
        lineQuantity := RTrim(lineQuantity, ".")

        this.data["data"] := {}
        this.data["data"]["inspectionFormNumber"] := lot.inspectionNumber
        this.data["data"]["reportDate"] := dateOfGeneration
        this.data["data"]["stelrayMaterialNumber"] := this.receiver.partNumber
        this.data["data"]["materialDescription"] := this.receiver.partDescription
        this.data["data"]["lotNumber"] := lot.lotNumber
        this.data["data"]["poNumber"] := this.receiver.poNumber
        this.data["data"]["vendorName"] := this.receiver.supplier
        this.data["data"]["quantityOnPo"] := lineQuantity
        this.data["data"]["quantityReceived"] := lot.quantity

        return this.data
    }

    verify(data)
    {
        data := data["data"]
        
        for index, expectedKey in this.expectedDataKeys {
            if (!data.hasKey(expectedKey)) {
                return false
            }
        }

        return true
    }

    execute()
    {
        inspectionReportConfig := Config.load("receiving.inspectionReport")
        template := inspectionReportConfig.get("file.template")
        destination := inspectionReportConfig.get("file.destinationFolder")
        tempDir := new #.Path.Temp("DBA AutoTools")

        reportData := this.data["data"]

        inspectionNumber := reportData["inspectionFormNumber"]
        inspectionFolder := #.Path.concat(destination, inspectionNumber)
        FileCreateDir, % inspectionFolder
        filename := inspectionNumber " - Inspection Report.xlsx"
        filepath := #.Path.concat(inspectionFolder, filename)
        #.Cmd.copy(template, filepath)

        if (#.Path.inUse(filepath)) {
            throw new @.FileInUseException(A_ThisFunc, "The filepath is currently in use", {filepath: filepath})
        }

        try {
            xlApp := ComObjCreate("Excel.Application")
            ; xlHwnd := xlApp.hwnd
            ; DetectHiddenWindows, On
            ; WinGet, xlProcessId, PID, % "ahk_id" xlHwnd
            #.log("queue").info(A_ThisFunc, "Created excel app")
            CurrWbk := xlApp.Workbooks.Open(filepath) ; Open the master file
            #.log("queue").info(A_ThisFunc, "Opened workbook")
            CurrSht := CurrWbk.Sheets(1)

            excelColumns := inspectionReportConfig.get("excelColumnMapping")

            for columnName, value in reportData {
                CurrSht.range[excelColumns.get(columnName)].Value := value
            }

            CurrWbk.Save()
            #.log("queue").info(A_ThisFunc, "Saved Workbook")

            xlApp.Quit()
            #.log("queue").info(A_ThisFunc, "Quit Excel App")
            xlApp := "", CurrWbk := "", CurrSht := "", xlHwnd := ""

        } catch e {
            throw e
        }
        return true
    }
}