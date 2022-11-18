#Include <Config>
class ConfigSuite
{
    class Initialization
    {
        CreatesIniFiles()
        {
            ; Make sure the .ini files DON'T exist yet
            Config._destroyGroupFiles()

            ; Reinitialize files
            Config._initialize()

            ; Make sure the .ini files DO exist
            for slug, group in Config.groups {
                Yunit.assert(group.exists(), "Configuration Group file '" group.path "' should exist")
            }
        }
    }
}

Config.register(new VerificationGroup())
Config.register(new PoReceivingGroup())
Config.load()

class PoReceivingGroup extends Config.Group
{
    define()
    {
        this.add("fields", new Config.StringField("Test Field"))
        this.add("stuff", new Config.NumberField("Test Field 2", {"default": 5, "slug": "specialSlug"}))
    }
}

class VerificationGroup extends Config.Group
{
    define()
    {
        this.add("defaults", new Config.DateField("Test Field"))
        this.add("main", new Config.FileField("Test Field 2"))
    }
}
