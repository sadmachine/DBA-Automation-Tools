#Include <Config>
#Include <File>
#Include <IniConfig>

MOCK_COMPILED := true

UI.Base.defaultFont := {options: "s12", fontName: ""}

class ConfigTests
{
    class Initialize
    {
        Begin()
        {
            IniRead, globalConfigLocation, % File.parseDirectory(A_LineFile) "/config.ini", % "location", % "global"
            IniRead, localConfigLocation, % File.parseDirectory(A_LineFile) "/config.ini", % "location", % "local"
            Config.setLocalConfigLocation(localConfigLocation)
            Config.setGlobalConfigLocation(globalConfigLocation)
            Config.register(new PoReceivingGroup())
            Config.register(new VerificationGroup())
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
            Config._destroyGroupFiles()
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
}

class PoReceivingGroup extends Config.Group
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

class VerificationGroup extends Config.Group
{
    define()
    {
        dateField := new Config.DateField("Date Field")
            .setOption("scope", Config.Scope.GLOBAL)
            .setOption("required", true)
        fileField := new Config.PathField("Path Field")
            .setOption("scope", Config.Scope.LOCAL)
            .setOption("required", true)
        dropdownField := new Config.DropdownField("Dropdown Field", ["Hey", "Hi", "Hello"])
            .setOption("scope", Config.Scope.LOCAL)
            .setOption("required", true)

        this.add("defaults", dateField)
        this.add("main", fileField)
        this.add("main", dropdownField)
    }
}
