#Include <Config>

class DatabaseGroup extends Config.Group
{
    define()
    {
        this.label := "Database"

        connectionFile := new Config.File("Connection")

        mainSection := new Config.Section("Main")
        mainSection.add(new Config.StringField("DSN").setOption("scope", Config.Scope.LOCAL))

        connectionFile.add(mainSection)
        this.add(connectionFile)
    }
}