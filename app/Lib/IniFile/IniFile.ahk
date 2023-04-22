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
; Revision 2 (03/21/2023)
; * Added helper `readObject` and `writeObject` methods for getting/setting
;
; Revision 3 (04/19/2023)
; * Update for ahk v2
; 
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Lib.Ini
class IniFile
{
    path := ""

    __New(path)
    {
        this.path := path
    }

    write(section, key, value)
    {
        IniWrite(value, this.path, section, key)
    }

    read(section, key, default := "__UNDEFINED__")
    {
        output := IniRead(this.path, section, key, default)
        return output
    }

    readSection(section)
    {
        output := IniRead(this.path, section)
        realOutput := Map()
        for n, pair in StrSplit(output, "`n") {
            pair := StrSplit(pair, "=")
            realOutput[pair[1]] := pair[2]
        }
        return realOutput
    }

    readSections()
    {
        output := IniRead(this.path)
        return StrSplit(output, "`n")
    }

    delete(section, key)
    {
        IniDelete(this.path, section, key)
    }

    deleteSection(section)
    {
        IniDelete(this.path, section)
    }

    readMap()
    {
        sections := this.readSections()
        m := Map()
        for n, sectionName in sections {
            m[sectionName] := this.readSection(sectionName)
        }
        return m
    }

    writeMap(m)
    {
        if (Core.typeOf(m) != "Object") {
            throw Core.ProgrammerException(A_ThisFunc, "Passed value must be an object", m)
        }

        for section, pair in m {
            if (Core.typeOf(pair) != "Object") {
                throw Core.ProgrammerException(A_ThisFunc, "Inner value must be an object", {parent: m, pair: pair})
            }
            for key, value in pair {
                this.write(section, key, value)
            }
        }
    }
}