#Include <Config>
#Include <String>

#Warn

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

Config.register(new VerificationGroup())
Config.register(new PoReceivingGroup())
Config.initialize()

Config.set("poReceiving.stuff.specialSlug", "cool value")
MsgBox % Config.get("poReceiving.stuff.specialSlug")
Config.setDefault("poReceiving.stuff.specialSlug")
MsgBox % Config.get("poReceiving.stuff.specialSlug")