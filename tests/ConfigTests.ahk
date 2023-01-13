#Include <Config>
#Include <File>
#Include <IniConfig>

MOCK_COMPILED := true

UI.Base.defaultFont := {options: "s12", fontName: ""}

class ConfigTests
{
    class GeneralUsage
    {
        Begin()
        {
            IniRead, globalConfigLocation, % File.parseDirectory(A_LineFile) "/config.ini", % "location", % "global"
            IniRead, localConfigLocation, % File.parseDirectory(A_LineFile) "/config.ini", % "location", % "local"
            Config.setLocalConfigLocation(localConfigLocation)
            Config.setGlobalConfigLocation(globalConfigLocation)
            Config.register(new TestOneGroup())
            Config.register(new TestTwoGroup())
            Config.initialize()
        }

        LoadRunsWithoutExceptions()
        {
            Config.load("testOne")
            Config.load("testTwo")
        }

        LoadReturnsTheConfigGroup()
        {
            thisGroup := Config.load("testOne")
            YUnit.assert(thisGroup.slug := "testOne", "thisGroup.slug, Expected: testOne, Actual: " thisGroup.slug)
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
            IniRead, globalConfigLocation, % File.parseDirectory(A_LineFile) "/config.ini", % "location", % "global"
            IniRead, localConfigLocation, % File.parseDirectory(A_LineFile) "/config.ini", % "location", % "local"
            Config.setLocalConfigLocation(localConfigLocation)
            Config.setGlobalConfigLocation(globalConfigLocation)
            Config.register(new TestOneGroup())
            Config.register(new TestTwoGroup())
        }

        CreatesIniFiles()
        {
            Config._destroyGroupFiles()
            ; Reinitialize files
            Config.initialize()

            ; Make sure the .ini files DO exist
            for slug, group in Config.groups {
                for slug, field in group.fields {
                    Yunit.assert(field.exists(), "Field '" field.slug "' did not exist in file '" field.path "'")
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
            IniRead, globalConfigLocation, % File.parseDirectory(A_LineFile) "/config.ini", % "location", % "global"
            IniRead, localConfigLocation, % File.parseDirectory(A_LineFile) "/config.ini", % "location", % "local"
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
            IniRead, globalConfigLocation, % File.parseDirectory(A_LineFile) "/config.ini", % "location", % "global"
            IniRead, localConfigLocation, % File.parseDirectory(A_LineFile) "/config.ini", % "location", % "local"
            Config.setLocalConfigLocation(localConfigLocation)
            Config.setGlobalConfigLocation(globalConfigLocation)
            Config.register(new TestOneGroup())
            Config.register(new TestTwoGroup())
        }

        OptionsAccessibleFromMainObject()
        {
            Config.groups["testOne"].fields["stringField"].setOption("test", 123)
            expectedValue := 123
            actualValue := config.groups["testOne"].fields["stringField"].test
            YUnit.assert(actualValue == expectedValue, "Expected: " expectedValue ", Actual: " actualValue)
        }

        End()
        {
            Config.clear()
        }
    }
}

class TestOneGroup extends Config.Group
{
    define()
    {
        stringField := new Config.StringField("String Field")
            .setOption("scope", Config.Scope.GLOBAL)
            .setOption("required", true)
        numberField := new Config.NumberField("Number Field")
            .setOption("scope", Config.Scope.LOCAL)
            .setOption("required", true)

        this.add("fields", stringField)
        this.add("stuff", numberField)
    }
}

class TestTwoGroup extends Config.Group
{
    define()
    {
        dateField := new Config.DateField("Date Field")
            .setOption("scope", Config.Scope.GLOBAL)
            .setOption("required", true)
        fileField := new Config.PathField("File Field")
            .setOption("scope", Config.Scope.LOCAL)
            .setOption("required", true)
        folderField := new Config.PathField("Folder Field")
            .setOption("pathType", "folder")
            .setOption("scope", Config.Scope.LOCAL)
            .setOption("required", true)
        dropdownField := new Config.DropdownField("Dropdown Field", ["Hey", "Hi", "Hello"])
            .setOption("scope", Config.Scope.LOCAL)
            .setOption("required", true)

        this.add("defaults", dateField)
        this.add("main", fileField)
        this.add("main", folderField)
        this.add("main", dropdownField)
    }
}
