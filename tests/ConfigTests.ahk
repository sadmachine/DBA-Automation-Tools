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
        this.add("fields", new Config.StringField("String Field", Config.Scope.GLOBAL, {required: true}))
        this.add("stuff", new Config.NumberField("Number Field", Config.Scope.LOCAL, {default: 5, slug: "specialSlug"}))
    }
}

class VerificationGroup extends Config.Group
{
    define()
    {
        this.add("defaults", new Config.DateField("Date Field", Config.Scope.GLOBAL, {required:true}))
        this.add("main", new Config.FileField("File Field", Config.Scope.LOCAL, {required:true}))
        this.add("main", new Config.DropdownField("Dropdown Field", ["hey", "hi", "hello"], Config.Scope.LOCAL, {required:true}))
    }
}
