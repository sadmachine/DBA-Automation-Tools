; === Script Information =======================================================
; Name .........: Config.Section
; Description ..: Handles config sections within .ini files
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/19/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Section.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/19/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Config.Section
class Section
{
    slug := ""
    label := ""
    fields := Map()
    fieldsByLabel := Map()
    file := ""
    initialized := false

    path[key] {
        get {
            if (!InStr("global local", key)) {
                throw Core.ProgrammerException(A_ThisFunc, "'" key "' is not a valid path key.")
            }
            return this.file.path[key]
        }
    }

    __New(label, slug := -1)
    {
        this.slug := slug
        this.label := label

        if (this.slug == -1) {
            this.slug := Str.toCamelCase(this.label)
        }
    }

    initialize(force := false)
    {
        if (this.initialized) {
            return
        }
        for fieldSlug, field in this.fields {
            field.section := this
            field.initialize(force)
            this.fieldsByLabel[field.label] := field
        }
        this.initialized := true
    }

    add(fieldObj)
    {
        this.fields[fieldObj.slug] := fieldObj
        this.fieldsByLabel[fieldObj.label] := fieldObj
        return this
    }

    get(identifier)
    {
        return this.fields[identifier].get()
    }

    set(identifier, value)
    {
        return this.fields[identifier].value := value
    }

    exists()
    {
        for fieldSlug, field in this.fields {
            if (!field.exists()) {
                return false
            }
        }
        return true
    }
}