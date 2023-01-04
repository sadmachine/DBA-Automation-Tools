#Include <Config>

class InspectionNumberConfig extends Config
{
    define()
    {
        this.label := "Inspection Number"

        this.add("Last", new Config.NumberField("Number"))
    }
}