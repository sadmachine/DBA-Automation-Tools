#Include <Config>

class ReceivingGroup extends Config.Group
{
    define()
    {
        this.label := "Receiving"

        this._defineInspectionReportFile()
        this._defineInspectionNumberFile()
    }

    _defineInspectionReportFile()
    {
        inspectionReportFile := new Config.File("Inspection Report")

        excelColumnMappingSection := new Config.Section("Excel Column Mapping")
            .add(new Config.StringField("Inspection Form Number"))
            .add(new Config.StringField("Stelray Material Number"))
            .add(new Config.StringField("Material Description"))
            .add(new Config.StringField("Lot Number"))
            .add(new Config.StringField("PO Number"))
            .add(new Config.StringField("Vendor Name"))
            .add(new Config.StringField("Quantity on PO"))
            .add(new Config.StringField("Quantity Received"))

        fileSection := new Config.Section("File")
            .add(new Config.PathField("Template", Config.Scope.LOCAL))
            .add(new Config.PathField("Destination Folder", Config.Scope.LOCAL))

        inspectionReportFile.add(excelColumnMappingSection)
        inspectionReportFile.add(fileSection)

        this.add(inspectionReportFile)
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
