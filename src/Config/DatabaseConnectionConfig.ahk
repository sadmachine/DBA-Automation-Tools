#Include <Config>

class DatabaseConnectionConfig extends Config
{
    define()
    {
        this.label := "Database Connection"

        this.add("database", new Config.StringField("dsn", Config.Scope.LOCAL))
    }
}