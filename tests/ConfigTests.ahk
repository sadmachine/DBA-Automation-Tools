#Include <Config>
#Include <File>
#Include <IniConfig>

MOCK_COMPILED := true

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
            ; Reinitialize files
            Config.initialize()

            ; Make sure the .ini files DO exist
            for slug, group in Config.groups {
                Yunit.assert(group.exists(), "Configuration Group file '" group.path "' should exist")
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
        this.add("fields", new Config.StringField("Test Field", Config.Scope.GLOBAL))
        this.add("stuff", new Config.NumberField("Test Field 2", Config.Scope.LOCAL, {"default": 5, "slug": "specialSlug"}))
    }
}

class VerificationGroup extends Config.Group
{
    define()
    {
        this.scope := Config.Scope.LOCAL_ONLY
        this.add("defaults", new Config.DateField("Test Field", Config.Scope.GLOBAL))
        this.add("main", new Config.FileField("Test Field 2", Config.Scope.LOCAL))
    }
}
