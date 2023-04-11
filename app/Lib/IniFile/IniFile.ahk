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
        realOutput := {}
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

    readObject()
    {
        sections := this.readSections()
        obj := Map()
        for n, sectionName in sections {
            obj[sectionName] := this.readSection(sectionName)
        }
        return obj
    }

    writeObject(obj)
    {
        if (Core.typeOf(obj) != "Object") {
            throw new Core.ProgrammerException(A_ThisFunc, "Passed value must be an object", obj)
        }

        for section, pair in obj {
            if (Core.typeOf(pair) != "Object") {
                throw new Core.ProgrammerException(A_ThisFunc, "Inner value must be an object", {parent: obj, pair: pair})
            }
            for key, value in pair {
                this.write(section, key, value)
            }
        }
    }
}