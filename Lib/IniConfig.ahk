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

    get(identifier)
    {
        parts := StrSplit(identifier, ".")
        section_title := parts[1]
        key := parts[2]
        IniRead, output, % this.getConfigPath(), % section_title, % key, ""
        return output
    }

    getSection(section_title)
    {
        output := {}
        IniRead, keys, % this.getConfigPath(), % section_title
        Loop, Parse, % keys, "`n" 
        {
            ini_parts := StrSplit(A_LoopField, "=")
            key := ini_parts[1]
            value := ini_parts[2]
            output[key] := value
        }
        return output
    }

    set(identifier, value)
    {
        parts := StrSplit(identifier, ".")
        section_title := parts[1]
        key := parts[2]
        IniWrite, % value, % this.getConfigPath(), % section_title, % key
    }

    setSection(section_title, values)
    {
        for key, value in values
        {
            IniWrite, % value, % this.getConfigPath(), % section_title, % key
        }
    }

    getAll()
    {
        output := {}
        IniRead, sections, % this.getConfigPath()
        Loop, Parse, % sections, "`n"
        {
            cur_section := StrReplace(A_LoopField, "_", " ")
            output[cur_section] := {}
            IniRead, keys, % this.getConfigPath(), % cur_section
            Loop, Parse, % keys, "`n" 
            {
                ini_parts := StrSplit(A_LoopField, "=")
                key := ini_parts[1]
                value := ini_parts[2]
                output[cur_section][key] := value
            }
        }
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