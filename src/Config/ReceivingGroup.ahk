#Include <Config>

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
        inspectionReportFile := new Config.File("Inspection Report")

        excelColumnMappingSection := new Config.Section("Excel Column Mapping")
        excelColumnMappingSection.add(new Config.StringField("Inspection Form Number")
            .setDefault("C2")
            .setDescription("The column/row to insert the Inspection Form Number. Example: 'C2' for column C, row 2."))
        excelColumnMappingSection.add(new Config.StringField("Report Date")
            .setDefault("C3")
            .setDescription("The column/row to insert the Report Date. Example: 'C2' for column C, row 2."))
        excelColumnMappingSection.add(new Config.StringField("Stelray Material Number")
            .setDefault("C4")
            .setDescription("The column/row to insert the Stelray Material Number. Example: 'C2' for column C, row 2."))
        excelColumnMappingSection.add(new Config.StringField("Material Description")
            .setDefault("C5")
            .setDescription("The column/row to insert the Material Description. Example: 'C2' for column C, row 2."))
        excelColumnMappingSection.add(new Config.StringField("Lot Number")
            .setDefault("C6")
            .setDescription("The column/row to insert the Lot Number. Example: 'C2' for column C, row 2."))
        excelColumnMappingSection.add(new Config.StringField("PO Number")
            .setDefault("H3")
            .setDescription("The column/row to insert the PO Number. Example: 'C2' for column C, row 2."))
        excelColumnMappingSection.add(new Config.StringField("Vendor Name")
            .setDefault("H4")
            .setDescription("The column/row to insert the Vendor Name. Example: 'C2' for column C, row 2."))
        excelColumnMappingSection.add(new Config.StringField("Quantity on PO")
            .setDefault("C10")
            .setDescription("The column/row to insert the Quantity on PO. Example: 'C2' for column C, row 2."))
        excelColumnMappingSection.add(new Config.StringField("Quantity Received")
            .setDefault("H10")
            .setDescription("The column/row to insert the Quantity Received. Example: 'C2' for column C, row 2."))

        fileSection := new Config.Section("File")
        fileSection.add(new Config.PathField("Template")
            .setScope(Config.Scope.LOCAL)
            .setDescription("The excel file that should be used as a template to create new Inspection Reports. The Excel Column Mapping configuration should line up with the columns/rows in this file."))
        fileSection.add(new Config.PathField("Destination Folder", "folder")
            .setScope(Config.Scope.LOCAL)
            .setDescription("The location on the filesystem that newly generated Inspection Reports should be placed."))

        inspectionReportFile.add(excelColumnMappingSection)
        inspectionReportFile.add(fileSection)

        this.add(inspectionReportFile)
    }

    _defineLogFile()
    {
        logFile := new Config.File("Log")

        excelColumnMappingSection := new Config.Section("Excel Column Mapping")
        excelColumnMappingSection.add(new Config.StringField("Date").setOption("default", "A"))
        excelColumnMappingSection.add(new Config.StringField("Stelray Item Number").setOption("default", "B"))
        excelColumnMappingSection.add(new Config.StringField("Material Description").setOption("default", "C"))
        excelColumnMappingSection.add(new Config.StringField("Material Lot Number").setOption("default", "D"))
        excelColumnMappingSection.add(new Config.StringField("Lot Quantity").setOption("default", "E"))
        excelColumnMappingSection.add(new Config.StringField("PO Number").setOption("default", "F"))
        excelColumnMappingSection.add(new Config.StringField("Inspection Number").setOption("default", "G"))
        excelColumnMappingSection.add(new Config.StringField("C of C Received").setOption("default", "H"))

        fileSection := new Config.Section("File")
        fileSection.add(new Config.PathField("Location").setScope(Config.Scope.LOCAL))

        logFile.add(excelColumnMappingSection)
        logFile.add(fileSection)

        this.add(logfile)
    }

    _defineLabelsFile()
    {
        labelsFile := new Config.File("Labels")

        printJobsSection := new Config.Section("Print Jobs")
        printJobsSection.add(new Config.PathField("Location", "directory").setScope(Config.Scope.LOCAL))

        labelsFile.add(printJobsSection)

        this.add(labelsFile)
    }

    _defineInspectionNumberFile()
    {
        inspectionNumberfile := new Config.File("Inspection Number")

        lastSection := new Config.Section("Last")
        lastSection.add(new Config.NumberField("Number").setDefault(100000))

        inspectionNumberFile.add(lastSection)

        this.add(inspectionNumberFile)
    }
}
