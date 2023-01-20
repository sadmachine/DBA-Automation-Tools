#Include <Config>

class ReceivingGroup extends Config.Group
{
    define()
    {
        this.label := "Receiving"

        this._defineInspectionReportFile()
        this._defineLogFile()
        this._defineInspectionNumberFile()
    }

    _defineInspectionReportFile()
    {
        inspectionReportFile := new Config.File("Inspection Report")

        excelColumnMappingSection := new Config.Section("Excel Column Mapping")
        excelColumnMappingSection.add(new Config.StringField("Inspection Form Number").setOption("default", "C2"))
        excelColumnMappingSection.add(new Config.StringField("Report Date").setOption("default", "C3"))
        excelColumnMappingSection.add(new Config.StringField("Stelray Material Number").setOption("default", "C4"))
        excelColumnMappingSection.add(new Config.StringField("Material Description").setOption("default", "C5"))
        excelColumnMappingSection.add(new Config.StringField("Lot Number").setOption("default", "C6"))
        excelColumnMappingSection.add(new Config.StringField("PO Number").setOption("default", "H3"))
        excelColumnMappingSection.add(new Config.StringField("Vendor Name").setOption("default", "H4"))
        excelColumnMappingSection.add(new Config.StringField("Quantity on PO").setOption("default", "C10"))
        excelColumnMappingSection.add(new Config.StringField("Quantity Received").setOption("default", "H10"))

        fileSection := new Config.Section("File")
        fileSection.add(new Config.PathField("Template").setScope(Config.Scope.LOCAL))
        fileSection.add(new Config.PathField("Destination Folder", "folder").setScope(Config.Scope.LOCAL))

        inspectionReportFile.add(excelColumnMappingSection)
        inspectionReportFile.add(fileSection)

        this.add(inspectionReportFile)
    }

    _defineLogFile()
    {
        logFile := new Config.File("Log")

        fileSection := new Config.Section("File")
        fileSection.add(new Config.PathField("Location").setScope(Config.Scope.LOCAL))

        logFile.add(fileSection)

        this.add(logfile)
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
