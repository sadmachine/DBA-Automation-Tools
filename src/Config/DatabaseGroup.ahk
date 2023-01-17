#Include <Config>

class DatabaseGroup extends Config.Group
{
    define()
    {
        this.label := "Database"

        connectionFile := new Config.File("Connection")

        mainSection := new Config.Section("Main")
            .add(new Config.StringField("dsn").setOption("scope", Config.Scope.LOCAL))

        connectionFile.add(mainSection)
    }
}