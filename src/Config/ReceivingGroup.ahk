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
            .add(new Config.StringField("Inspection Form Number").setDefault("C2"))
            .add(new Config.StringField("Report Date").setDefault("C3"))
            .add(new Config.StringField("Stelray Material Number").setDefault("C4"))
            .add(new Config.StringField("Material Description").setDefault("C5"))
            .add(new Config.StringField("Lot Number").setDefault("C6"))
            .add(new Config.StringField("PO Number").setDefault("H3"))
            .add(new Config.StringField("Vendor Name").setDefault("H4"))
            .add(new Config.StringField("Quantity on PO").setDefault("C10"))
            .add(new Config.StringField("Quantity Received").setDefault("H10"))

        fileSection := new Config.Section("File")
            .add(new Config.PathField("Template").setScope(Config.Scope.LOCAL))
            .add(new Config.PathField("Destination Folder").setScopr(Config.Scope.LOCAL))

        inspectionReportFile.add(excelColumnMappingSection)
        inspectionReportFile.add(fileSection)

        this.add(inspectionReportFile)
    }

    _defineLogFile()
    {
        logFile := new Config.File("Log")

        fileSection := new Config.Section("File")
            .add(new Config.PathField("Location", Config.Scope.LOCAL))

        logFile.add(fileSection)

        this.add(logfile)
    }

    _defineInspectionNumberFile()
    {
        inspectionNumberfile := new Config.File("Inspection Number")

        lastSection := new Config.Section("Last")
            .add(new Config.NumberField("Number"))

        inspectionNumberFile.add(lastSection)

        this.add(inspectionNumberFile)
    }
}
