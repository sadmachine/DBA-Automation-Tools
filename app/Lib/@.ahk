; === Script Information =======================================================
; Name .........: @ (at symbol)
; Description ..: Holds type and exception utilities classes/methods
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/21/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: @.ahk
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
; Revision 4 (05/18/2023)
; * Handle system exceptions better
;
; === TO-DOs ===================================================================
; ==============================================================================
Class @
{
    #Include <@Exceptions/BaseException>
    #Include <@Exceptions/ConnectivityException>
    #Include <@Exceptions/EnvironmentException>
    #Include <@Exceptions/ExpectedException>
    #Include <@Exceptions/FilesystemException>
    #Include <@Exceptions/FileInUseException>
    #Include <@Exceptions/NoRowsException>
    #Include <@Exceptions/NotFoundException>
    #Include <@Exceptions/ProgrammerException>
    #Include <@Exceptions/RequiredFieldException>
    #Include <@Exceptions/SQLException>
    #Include <@Exceptions/UnexpectedException>
    #Include <@Exceptions/ValidationException>

    static primitiveTypes := "Empty,Object,Array,Digit,Float,Hexadecimal,Integer,DateTime,String"

    typeOf(variable)
    {
        if (IsObject(variable)) {
            if (variable.__Class != "") {
                return variable.__Class
            } else if (variable.MaxIndex() == "" && variable.MinIndex() == "" && variable.Count() == 0) {
                return "Empty"
            } else {
                for index, value in variable {
                    if index is not digit
                    {
                        return "Object"
                    }
                }
                return "Array"
            }
        }
        if (variable == "")
            return "Empty"
        if variable is digit
            return "Digit"
        if variable is float
            return "Float"
        if variable is xdigit
            return "Hexadecimal"
        if variable is integer
            return "Integer"
        if variable is space
            return "Empty"
        if variable is time
            return "DateTime"
        return "String"
    }

    isPrimitiveType(instance)
    {
        if (InStr(@.primitiveTypes, @.typeOf(instance))) {
            return true
        }
    }

    subclassOf(instance, className)
    {
        ; If our instance is a primitive type, return false
        if (@.isPrimitiveType(instance)) {
            return false
        }
        return (InStr(@.typeOf(instance), className ".") != 0)
    }

    inheritsFrom(instance, className)
    {
        if (@.isPrimitiveType(instance)) {
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

    friendlyException(e, showData := false)
    {
        if ($["DEBUG_MODE"] || @.inheritsFrom(e, "UnexpectedException")) {
            if (!@.handleException(e)) {
                throw e
            }
        } else {
            message := e.message
            if (showData && e.data != "" && e.data != {}) {
                message .= "`nContext:`n" Trim(@.vardump(e.data), "{}`n`s`r")
            }
            if (@.subclassOf(e, "@")) {
                UI.MsgBox(message, e.what)
            } else {
                throw e
            }
        }
    }

    handleException(e)
    {
        if (@.subclassOf(e, "@")) {
            output := ""
            output .= "Exception: `t" e.what "`n"
            output .= "Where: `t`t" e.where "`n`n"
            output .= "Details: `n" e.message
            if (e.data != "") {
                output .= "Context: `n" @.vardump(e.data)
            }
            #.log("app").error(e.where, "<" e.what "> " e.message)
            UI.MsgBox(output, "Exception Occurred")
            return 1
        }
        return 0
    }

    registerExceptionHandler()
    {
        Global
        handleExceptionFunc := ObjBindMethod(@, "handleException")
        OnError(handleExceptionFunc, 1)
    }

    vardump(data, level := 0)
    {
        if (!IsObject(data)) {
            if (@.typeOf(data) == "Empty") {
                return ""
            }
            if (@.typeof(data) == "String") {
                return """" data """,`n"
            } 
            return data ",`n"
        }

        indentStep := "` ` ` ` "
        indentMore := "" indentStep
        indent := ""
        Loop % level {
            indent .= indentStep
            indentMore .= indentStep
        }

        dataStr := ""

        dataStr .= "{`n"
        for index, value in data {
            dataStr .= indentMore index ": " @.vardump(value, level+1)
        }
        dataStr .= indent "}"
        if (level != 0) {
            dataStr .= ","
        }
        dataStr .= "`n"

        return dataStr
    }
}