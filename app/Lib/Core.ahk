; === Script Information =======================================================
; Name .........: @ (at symbol)
; Description ..: Holds type and exception utilities classes/methods
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/21/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Core.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/21/2023)
; * Added This Banner
;
; Revision 2 (03/21/2023)
; * Created vardump helper for turning any variable into a string for output
; * Vardump get used for data that is passed to exceptions for displaying
;
; Revision 3 (03/31/2023)
; * Update how global vars are handled
;
; === TO-DOs ===================================================================
; ==============================================================================
Class Core
{
    #Include "Exceptions/BaseException.ahk"
    #Include "Exceptions/ConnectivityException.ahk"
    #Include "Exceptions/EnvironmentException.ahk"
    #Include "Exceptions/ExpectedException.ahk"
    #Include "Exceptions/FilesystemException.ahk"
    #Include "Exceptions/FileInUseException.ahk"
    #Include "Exceptions/NoRowsException.ahk"
    #Include "Exceptions/NotFoundException.ahk"
    #Include "Exceptions/ProgrammerException.ahk"
    #Include "Exceptions/RequiredFieldException.ahk"
    #Include "Exceptions/SQLException.ahk"
    #Include "Exceptions/UnexpectedException.ahk"
    #Include "Exceptions/ValidationException.ahk"

    static primitiveTypes := "Empty,Object,Array,Digit,Float,Hexadecimal,Integer,DateTime,String"

    typeOf(variable)
    {
        if (IsObject(variable)) {
            if (variable.__Class != "") {
                return variable.__Class
            } else if (variable.MaxIndex() == "" && variable.MinIndex() == "" && variable.Count == 0) {
                return "Empty"
            } else {
                for index, value in variable {
                    if !isDigit(index)
                    {
                        return "Object"
                    }
                }
                return "Array"
            }
        }
        if (variable == "")
            return "Empty"
        if isDigit(variable)
            return "Digit"
        if isFloat(variable)
            return "Float"
        if isXdigit(variable)
            return "Hexadecimal"
        if isInteger(variable)
            return "Integer"
        if isSpace(variable)
            return "Empty"
        if isTime(variable)
            return "DateTime"
        return "String"
    }

    isPrimitiveType(instance)
    {
        if (InStr(Core.primitiveTypes, Core.typeOf(instance))) {
            return true
        }
    }

    subclassOf(instance, className)
    {
        ; If our instance is a primitive type, return false
        if (Core.isPrimitiveType(instance)) {
            return false
        }
        return (InStr(Core.typeOf(instance), className ".") != 0)
    }

    inheritsFrom(instance, className)
    {
        if (Core.isPrimitiveType(instance)) {
            return false
        }
        base := instance.base
        while (base != "") {
            if (base.__Class == className) {
                return true
            }
            base := base.base
        }
        return false
    }

    friendlyException(e)
    {
        if (Env["DEBUG_MODE"] || Core.inheritsFrom(e, "UnexpectedException")) {
            if (!Core.handleException(e)) {
                throw e
            }
        } else {
            UI.MsgBox(e.message, e.what)
        }
    }

    handleException(e)
    {
        if (Core.subclassOf(e, "Core")) {
            output := ""
            output .= "Exception: `t" e.what "`n"
            output .= "Where: `t`t" e.where "`n`n"
            output .= "Details: `n" e.message
            if (e.data != "") {
                output .= "Context: `n" Core.vardump(e.data)
            }
            Lib.log("app").error(e.where, "<" e.what "> " e.message)
            UI.MsgBox(output, "Exception Occurred")
            return 1
        }
        return 0
    }

    registerExceptionHandler()
    {
        Global
        handleExceptionFunc := ObjBindMethod(Core, "handleException")
        OnError(%handleExceptionFunc%, 1)
    }

    vardump(data, level := 0)
    {
        if (!IsObject(data)) {
            if (Core.typeof(data) == "String") {
                return """" data """,`n"
            }
            return data ",`n"
        }

        indentStep := "` ` ` ` "
        indentMore := "" indentStep
        indent := ""
        Loop level {
            indent .= indentStep
            indentMore .= indentStep
        }

        dataStr := ""

        dataStr .= "{`n"
        for index, value in data {
            dataStr .= indentMore index ": " Core.vardump(value, level+1)
        }
        dataStr .= indent "}"
        if (level != 0) {
            dataStr .= ","
        }
        dataStr .= "`n"
        return dataStr
    }
}