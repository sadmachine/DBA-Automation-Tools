; === Script Information =======================================================
; Name .........: Receiving Configuration Group
; Description ..: Configuration settings for receiving processes
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: ReceivingGroup.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; Revision 2 (04/21/2023)
; * Update for ahk v2
; 
; === TO-DOs ===================================================================
; ==============================================================================
class ReceivingGroup extends Config.Group
{
    define()
    {
        this.label := "Receiving"

        this._defineInspectionReportFile()
        this._defineLogFile()
        this._defineLabelsFile()
        this._defineInspectionNumberFile()
    }

    _defineInspectionReportFile()
    {
        inspectionReportFile := Config.File("Inspection Report")

        excelColumnMappingSection := Config.Section("Excel Column Mapping")
        excelColumnMappingSection.add(Config.StringField("Inspection Form Number")
            .setDefault("C2")
            .setDescription("The column/row to insert the Inspection Form Number. Example: 'C2' for column C, row 2."))
        excelColumnMappingSection.add(Config.StringField("Report Date")
            .setDefault("C3")
            .setDescription("The column/row to insert the Report Date. Example: 'C2' for column C, row 2."))
        excelColumnMappingSection.add(Config.StringField("Stelray Material Number")
            .setDefault("C4")
            .setDescription("The column/row to insert the Stelray Material Number. Example: 'C2' for column C, row 2."))
        excelColumnMappingSection.add(Config.StringField("Material Description")
            .setDefault("C5")
            .setDescription("The column/row to insert the Material Description. Example: 'C2' for column C, row 2."))
        excelColumnMappingSection.add(Config.StringField("Lot Number")
            .setDefault("C6")
            .setDescription("The column/row to insert the Lot Number. Example: 'C2' for column C, row 2."))
        excelColumnMappingSection.add(Config.StringField("PO Number")
            .setDefault("H3")
            .setDescription("The column/row to insert the PO Number. Example: 'C2' for column C, row 2."))
        excelColumnMappingSection.add(Config.StringField("Vendor Name")
            .setDefault("H4")
            .setDescription("The column/row to insert the Vendor Name. Example: 'C2' for column C, row 2."))
        excelColumnMappingSection.add(Config.StringField("Quantity on PO")
            .setDefault("C10")
            .setDescription("The column/row to insert the Quantity on PO. Example: 'C2' for column C, row 2."))
        excelColumnMappingSection.add(Config.StringField("Quantity Received")
            .setDefault("H10")
            .setDescription("The column/row to insert the Quantity Received. Example: 'C2' for column C, row 2."))

        fileSection := Config.Section("File")
        fileSection.add(Config.PathField("Template")
            .setDescription("The excel file that should be used as a template to create Inspection Reports. The Excel Column Mapping configuration should line up with the columns/rows in this file."))
        fileSection.add(Config.PathField("Destination Folder", "directory")
            .setDescription("The location on the filesystem that newly generated Inspection Reports should be placed."))

        inspectionReportFile.add(excelColumnMappingSection)
        inspectionReportFile.add(fileSection)

        this.add(inspectionReportFile)
    }

    _defineLogFile()
    {
        logFile := Config.File("Incoming Inspection Log")

        excelColumnMappingSection := Config.Section("Excel Column Mapping")
        excelColumnMappingSection.add(Config.StringField("Date")
            .setDefault("A")
            .setDescription("The column to insert the Receive Date. Example: 'A' for column A."))
        excelColumnMappingSection.add(Config.StringField("Stelray Item Number")
            .setDefault("B")
            .setDescription("The column to insert the Stelray Item Number. Example: 'B' for column B."))
        excelColumnMappingSection.add(Config.StringField("Material Description")
            .setDefault("C")
            .setDescription("The column to insert the Material Description. Example: 'C' for column C."))
        excelColumnMappingSection.add(Config.StringField("Material Lot Number")
            .setDefault("D")
            .setDescription("The column to insert the Material Lot Number. Example: 'D' for column D."))
        excelColumnMappingSection.add(Config.StringField("Lot Quantity")
            .setDefault("E")
            .setDescription("The column to insert the Lot Quantity. Example: 'E' for column E."))
        excelColumnMappingSection.add(Config.StringField("PO Number")
            .setDefault("F")
            .setDescription("The column to insert the PO Number. Example: 'F' for column F."))
        excelColumnMappingSection.add(Config.StringField("Inspection Number")
            .setDefault("G")
            .setDescription("The column to insert the Inspection Number. Example: 'G' for column G."))
        excelColumnMappingSection.add(Config.StringField("C of C Received")
            .setDefault("H")
            .setDescription("The column to insert the C of C Received. Example: 'H' for column H."))
        excelColumnMappingSection.add(Config.StringField("Receiver ID")
            .setDefault("I")
            .setDescription("The column to insert the Receiver ID. Example: 'I' for column I."))

        fileSection := Config.Section("File")
        fileSection.add(Config.PathField("Template")
            .setDescription("The template file to use for the Incoming Inspection Log if the Incoming Inspection Log does not already exist. This should be an .xlsx file."))
        fileSection.add(Config.PathField("Destination", "directory")
            .setDescription("The directory where the Incoming Inspection Log file is found. If the file does not exist already, it will be created from the template specified by 'Receiving.Incoming Inspection.Log File.Template'."))

        logFile.add(excelColumnMappingSection)
        logFile.add(fileSection)

        this.add(logfile)
    }

    _defineLabelsFile()
    {
        labelsFile := Config.File("Labels")

        printJobsSection := Config.Section("Print Jobs")
        printJobsSection.add(Config.PathField("Location", "directory")
            .setDescription("The directory that the Receiving Label print job .csv files should be placed to be picked up by the print server."))

        labelsFile.add(printJobsSection)

        this.add(labelsFile)
    }

    _defineInspectionNumberFile()
    {
        inspectionNumberfile := Config.File("Inspection Number")

        lastSection := Config.Section("Last")
        lastSection.add(Config.NumberField("Number")
            .setDefault(100000)
            .setDescription("The last inspection number that was used. The next inspection number will be the current number +1."))

        inspectionNumberFile.add(lastSection)

        this.add(inspectionNumberFile)
    }
}
