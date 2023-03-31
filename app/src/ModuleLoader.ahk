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
; === TO-DOs ===================================================================
; TODO - Possibly turn this into a controller
; TODO - Revisit/refactor/optimize
; ==============================================================================
#Include src\ModuleObj.ahk

class ModuleLoader
{
    static modules := {}
    static sections := {}
    static module_titles := []
    static section_titles := []
    static module_location := ""

    __New(mods_location)
    {
        this.boot(mods_location)
    }

    boot(mods_location)
    {
        Global
        local value, key, module, ini_parts, mod_sections, mod_keys, cur_section, output
        this.module_location := mods_location
        IniRead, mod_sections, % this.module_location "/mods.ini"
        Loop, Parse, % mod_sections, "`n"
        {
            cur_section := StrReplace(A_LoopField, "_", " ")
            this.sections[cur_section] := {}
            this.section_titles.push(cur_section)
            IniRead, mod_keys, % this.module_location "/mods.ini", % cur_section
            Loop, Parse, % mod_keys, "`n"
            {
                ini_parts := StrSplit(A_LoopField, "=")
                key := StrReplace(ini_parts[1], "_" , " ")
                value := ini_parts[2]
                module := new ModuleObj(key, cur_section, value)
                this.modules[key] := module
                this.sections[cur_section][key] := module
                this.module_titles.push(key)
            }
        }

        if ($["DEBUG_MODE"])
        {
            output := "Loaded modules: `n"
            for _n, _mod in this.modules
            {
                output := output "[" _mod.section_title "] " _mod.title " => " _mod.file "`n"
            }
            MsgBox % output
        }
    }

    get(module)
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