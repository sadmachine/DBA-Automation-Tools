#Include <Config>

class DatabaseConnectionConfig extends Config
{
    define()
    {
        this.label := "Database Connection"

        dsnField := new Config.StringField("dsn")
            .setOption("scope", Config.Scope.LOCAL)

        this.add("database", dsnField)
    }
}