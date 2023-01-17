#Include <Config>

class InspectionReportGroup extends Config.Group
{
    define()
    {
        this.label := "Inspection Report"

        this.add("excel_mapping", new Config.StringField("Inspection Form Number"))
        this.add("excel_mapping", new Config.StringField("Stelray Material Number"))
        this.add("excel_mapping", new Config.StringField("Material Description"))
        this.add("excel_mapping", new Config.StringField("Lot Number"))
        this.add("excel_mapping", new Config.StringField("PO Number"))
        this.add("excel_mapping", new Config.StringField("Vendor Name"))
        this.add("excel_mapping", new Config.StringField("Quantity on PO"))
        this.add("excel_mapping", new Config.StringField("Quantity Received"))

        this.add("file", new Config.PathField("Template", Config.Scope.LOCAL))
        this.add("file", new Config.PathField("Destination Folder", Config.Scope.LOCAL))
    }
}