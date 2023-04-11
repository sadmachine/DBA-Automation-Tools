#Include <Config>
#Include <#>

MOCK_COMPILED := true

UI.Base.defaultFont := {options: "s12", fontName: ""}

class ConfigTests
{
    class GeneralUsage
    {
        Begin()
        {
            globalConfigLocation := IniRead(Lib.Path.parseDirectory(A_LineFile) "/config.ini", "location", "global")
            localConfigLocation := IniRead(Lib.Path.parseDirectory(A_LineFile) "/config.ini", "location", "local")
            Config.setLocalConfigLocation(localConfigLocation)
            Config.setGlobalConfigLocation(globalConfigLocation)
            Config.register(ContactGroup())
            Config.register(CustomerGroup())
            Config.initialize()
        }

        LoadRunsWithoutExceptions()
        {
            Config.load("contact.list")
            Config.load("customers.list")
        }

        LoadReturnsTheConfigGroup()
        {
            thisGroup := Config.load("contact.list")
            YUnit.assert(thisGroup.slug := "list", "thisGroup.slug, Expected: list, Actual: " thisGroup.slug)
        }

        LoadThenGetReturnsCorrectValue()
        {
            expectedValue := 26
            actualValue := Config.load("contact.list").get("entries.age")
            YUnit.assert(expectedValue == actualValue, "contact.list.entries.age should be equal to " expectedValue " but found " actualValue)
        }

        LockCreatesLockFile()
        {
            Config.lock("contact.list", Config.Scope.GLOBAL)

            MsgBox("Check")
            fileObj := Config.groups["contact"].files["list"]
            if (FileExist(fileObj.path["global"])) {
                globalIsLocked := Lib.Path.isLocked(fileObj.path["global"])
                YUnit.assert(globalIsLocked, "Global path for contact.list should be locked, but isnt.'")
            }
            if (FileExist(fileObj.path["local"])) {
                localIsLocked := Lib.Path.isLocked(fileObj.path["local"])
                YUnit.assert(localIsLocked, "Local path for contact.list should be locked, but isnt.'")
            }
            Config.unlock("contact.list")
        }

        End()
        {
            Config.clear()
        }
    }

    class Initialize
    {
        Begin()
        {
            globalConfigLocation := IniRead(Lib.Path.parseDirectory(A_LineFile) "/config.ini", "location", "global")
            localConfigLocation := IniRead(Lib.Path.parseDirectory(A_LineFile) "/config.ini", "location", "local")
            Config.setLocalConfigLocation(localConfigLocation)
            Config.setGlobalConfigLocation(globalConfigLocation)
        }

        CreatesIniFiles()
        {
            Config.register(ContactGroup())
            Config.register(CustomerGroup())
            Config._deletePaths()
            ; Reinitialize files
            Config.initialize()
            MsgBox("Check files")

            ; Make sure the .ini files DO exist
            for groupSlug, group in Config.groups {
                for fileSlug, file in group.files {
                    for sectionSlug, section in file.sections {
                        for fieldSlug, field in section.fields {
                            Yunit.assert(field.exists(), "Field '" field.slug "' did not exist in file '" field.path "'")
                        }
                    }
                }
            }
        }

        RequiredFieldsPromptForValue()
        {
            Config.register(RequiredContactGroup())
            Config.register(RequiredCustomerGroup())
            Config._deletePaths()
            ; Reinitialize files
            Config.initialize()

            ; Make sure the .ini files DO exist
            for groupSlug, group in Config.groups {
                for fileSlug, file in group.files {
                    for sectionSlug, section in file.sections {
                        for fieldSlug, field in section.fields {
                            Yunit.assert(field.exists(), "Field '" field.slug "' did not exist in file '" field.path "'")
                        }
                    }
                }
            }
        }

        End()
        {
            Config.clear()
        }
    }

    class Locations
    {
        Begin()
        {
            globalConfigLocation := IniRead(Lib.Path.parseDirectory(A_LineFile) "/config.ini", "location", "global")
            localConfigLocation := IniRead(Lib.Path.parseDirectory(A_LineFile) "/config.ini", "location", "local")
            this.globalConfigLocation := globalConfigLocation
            this.localConfigLocation := localConfigLocation
        }

        ProperlySetLocalConfig()
        {
            Config.setLocalConfigLocation(this.localConfigLocation)
            Yunit.assert(Config.localConfigLocation == this.localConfigLocation, Config.localConfigLocation " != " this.localConfigLocation)
        }

        ProperlySetGlobalConfig()
        {
            Config.setGlobalConfigLocation(this.globalConfigLocation)
            Yunit.assert(Config.globalConfigLocation == this.globalConfigLocation, Config.globalConfigLocation " != " this.globalConfigLocation)
        }
    }

    class Fields
    {
        Begin()
        {
            globalConfigLocation := IniRead(Lib.Path.parseDirectory(A_LineFile) "/config.ini", "location", "global")
            localConfigLocation := IniRead(Lib.Path.parseDirectory(A_LineFile) "/config.ini", "location", "local")
            Config.setLocalConfigLocation(localConfigLocation)
            Config.setGlobalConfigLocation(globalConfigLocation)
            Config.register(ContactGroup())
            Config.register(CustomerGroup())
            Config.initialize()
        }

        OptionsAccessibleFromMainObject()
        {
            expectedValue := 123
            Config.groups["contact"].files["list"].sections["entries"].fields["name"].setOption("test", expectedValue)
            actualValue := Config.groups["contact"].files["list"].sections["entries"].fields["name"].test
            YUnit.assert(actualValue == expectedValue, "Expected: " expectedValue ", Actual: " actualValue)
        }

        End()
        {
            Config.clear()
        }
    }
}

class ContactGroup extends Config.Group
{
    define()
    {
        this.label := "Contact"

        listFile := Config.File("List")

        entriesSection := Config.Section("Entries")
        entriesSection.add(Config.StringField("Name").setDefault("Austin"))
        entriesSection.add(Config.NumberField("Age").setDefault("26"))

        historySection := Config.Section("History")
        historySection.add(Config.DateField("Last Contact").setOption("default", "20220101123456"))
        historySection.add(Config.PathField("Location", "folder").setOption("default", "C:\Config"))

        listFile.add(entriesSection)            .add(historySection)

        this.add(listFile)
    }
}

class CustomerGroup extends Config.Group
{
    define()
    {
        this.label := "Customers"

        listFile := Config.File("List")

        mainSection := Config.Section("Main")            
            .add(Config.DropdownField("Type", ["Good", "Bad", "Ugly"])
                .setOption("default", "Ugly"))            
            .add(Config.NumberField("Rating")
                .setOption("min", 1)
                .setOption("max", 5)
                .setOption("default", "3"))

        listFile.add(mainSection)

        this.add(listFile)
    }
}

class RequiredContactGroup extends Config.File
{
    define()
    {
        this.label := "Contact"

        listFile := Config.File("List")

        entriesSection := Config.Section("Entries")
            .add(Config.StringField("Name")
                .setOption("default", "Austin")
                .setOption("required", true))            
            .add(Config.NumberField("Age")
                .setOption("default", "26")
                .setOption("required", true))

        historySection := Config.Section("History")
            .add(Config.DateField("Last Contact")
                .setOption("default", "20220101123456")
                .setOption("required", true))
            .add(Config.PathField("Location", "folder")
                .setOption("default", "C:\Config")
                .setOption("required", true))

        listFile.add(entriesSection)            .add(historySection)

        this.add(listFile)
    }
}

class RequiredCustomerGroup extends Config.File
{
    define()
    {
        this.label := "Customers"

        listFile := Config.File("List")

        mainSection := Config.Section("Main")
            .add(Config.DropdownField("Type", ["Good", "Bad", "Ugly"])
                .setOption("default", "Ugly")
                .setOption("required", true))
            .add(Config.NumberField("Rating", 1, 5)
                .setOption("default", "3")
                .setOption("required", true))

        listFile.add(mainSection)

        this.add(listFile)
    }
}

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
        inspectionReportFile := Config.File("Inspection Report")

        excelColumnMappingSection := Config.Section("Excel Column Mapping")
            .add(Config.StringField("Inspection Form Number"))
            .add(Config.StringField("Stelray Material Number"))
            .add(Config.StringField("Material Description"))
            .add(Config.StringField("Lot Number"))
            .add(Config.StringField("PO Number"))
            .add(Config.StringField("Vendor Name"))
            .add(Config.StringField("Quantity on PO"))
            .add(Config.StringField("Quantity Received"))

        fileSection := Config.Section("File")
            .add(Config.PathField("Template", Config.Scope.LOCAL))
            .add(Config.PathField("Destination Folder", Config.Scope.LOCAL))

        inspectionReportFile.add(excelColumnMappingSection)
        inspectionReportFile.add(fileSection)

        this.add(inspectionReportFile)
    }

    _defineInspectionNumberFile()
    {
        inspectionNumberfile := Config.File("Inspection Number")

        lastSection := Config.Section("Last")
        .add(Config.NumberField("Number"))

        inspectionNumberFile.add(lastSection)

        this.add(inspectionNumberFile)
    }
}