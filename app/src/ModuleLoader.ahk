; === Script Information =======================================================
; Name .........: Module Loader
; Description ..: Handles loading and general module operations
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: ModuleLoader.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; Revision 2 (03/31/2023)
; * Update how global vars are access
;
; Revision 3 (04/09/2023)
; * Update to use mods_ini instead of mods location
;
; Revision 4 (04/09/2023)
; * Added `has` method to check for existing module
;
; Revision 5 (04/21/2023)
; * Update for ahk v2
; 
; === TO-DOs ===================================================================
; TODO - Possibly turn this into a controller
; TODO - Revisit/refactor/optimize
; ==============================================================================
#Include "ModuleObj.ahk"

class ModuleLoader
{
    static modules := Map()
    static sections := Map()
    static module_titles := []
    static section_titles := []
    static module_location := ""
    static mods_ini := ""

    __New(mods_location, mods_ini)
    {
        this.boot(mods_location, mods_ini)
    }

    boot(mods_location, mods_ini)
    {
        Global
        local value, key, module, ini_parts, mod_sections, mod_keys, cur_section, output
        this.module_location := mods_location
        this.mods_ini := mods_ini
        mod_sections := IniRead(mods_ini)
        Loop Parse, mod_sections, "`n"
        {
            cur_section := StrReplace(A_LoopField, "_", " ")
            this.sections[cur_section] := Map()
            this.section_titles.push(cur_section)
            mod_keys := IniRead(mods_ini, cur_section)
            Loop Parse, mod_keys, "`n"
            {
                ini_parts := StrSplit(A_LoopField, "=")
                key := StrReplace(ini_parts[1], "_", " ")
                value := ini_parts[2]
                module := ModuleObj(key, cur_section, value)
                this.modules[key] := module
                this.sections[cur_section][key] := module
                this.module_titles.push(key)
            }
        }

        if (Env["DEBUG_MODE"])
        {
            output := "Loaded modules: `n"
            for _n, _mod in this.modules
            {
                output := output "[" _mod.section_title "] " _mod.title " => " _mod.file "`n"
            }
            MsgBox(output)
        }
    }

    get(module)
    {
        return this.modules[module]
    }

    has(module)
    {
        return this.modules.Has(module)
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