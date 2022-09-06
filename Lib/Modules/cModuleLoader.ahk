class cModuleLoader
{
    modules         := []
    sections        := []
    module_titles   := []
    section_titles  := []
    module_location := ""

    __New(mods_location)
    {
        this.module_location := mods_location
        IniRead, mod_sections, % this.module_location "/mods.ini"
        Loop, Parse, % mod_sections, "`n"
        {
            cur_section := StrReplace(A_LoopField, "_", " ")
            this.sections[cur_section] := []
            this.section_titles.push(cur_section)
            MsgBox % cur_section
            IniRead, mod_keys, % this.module_location "/mods.ini", % cur_section
            Loop, Parse, % mod_keys, "`n" 
            {
                ini_parts := StrSplit(A_LoopField, "=")
                key := StrReplace(ini_parts[1], "_" , " ")
                value := ini_parts[2]
                module := new cModule(value, cur_section, value)
                MsgBox % key " " value
                this.modules[key] := module
                this.sections[cur_section][key] := module
                this.module_titles.push(key)
            }
        }
    }

    getModule(module)
    {
        return this.modules[module]
    }

    getSectionModules(section_title) 
    {
        return this.modules_by_section[section_title]
    }

    getModuleTitles()
    {
        return this.module_titles
    }

    getSectionTitles(section_title)
    {
        return this.module_section_titles
    }

}