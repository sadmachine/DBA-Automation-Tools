; === Script Information =======================================================
; Name .........: Ini
; Description ..: A convenience class for INI file opterations
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/15/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Ini.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/15/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; #.Ini
class IniFile
{
    path := ""

    __New(path)
    {
        this.path := path
    }

    write(section, key, value)
    {
        IniWrite, % value, % this.path, % section, % key
    }

    read(section, key, default := "__UNDEFINED__")
    {
        IniRead, output, % this.path, % section, % key, % default
        return output
    }

    readSection(section)
    {
        IniRead, output, % this.path, % section
        realOutput := {}
        for n, pair in StrSplit(output, "`n") {
            pair := StrSplit(pair, "=")
            realOutput[pair[1]] := pair[2]
        }
        return realOutput
    }

    readSections()
    {
        IniRead, output, % this.path
        return StrSplit(output, "`n")
    }

    delete(section, key)
    {
        IniDelete, % this.path, % section, % key
    }

    deleteSection(section)
    {
        IniDelete, % this.path, % section
    }
}