class IniConfig
{
    config_name := ""
    filename := ""
    base_path := A_ScriptDir "/config"

    __New(config_name, base_path := 0)
    {
        if (base_path != 0)
        {
            this.base_path := base_path
        }
        this.config_name := config_name
        ;dotpath := StrReplace(config_name, ".", "/")
        this.filename := this.config_name ".ini"
    }

    exists()
    {
        return FileExist(this.getConfigPath())
    }

    get(key, section:="main")
    {
        IniRead, output, % this.getConfigPath(), % section, % key, ""
        return output
    }

    set(key, value, section:="main")
    {
        IniWrite, % value, % this.getConfigPath(), % section, % key
    }

    getConfigPath()
    {
        if (FileExist(this.base_path) != "D")
        {
            FileCreateDir, % this.base_path
        }
        return this.base_path "/" this.filename
    }

    setBasePath(path)
    {
        this.base_path:= RTrim(location, "\/")
    }
}