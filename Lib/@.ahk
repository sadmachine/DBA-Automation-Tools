Class @
{
    #Include <Exceptions/BaseException>
    #Include <Exceptions/ConnectivityException>
    #Include <Exceptions/EnvironmentException>
    #Include <Exceptions/ExpectedException>
    #Include <Exceptions/FilesystemException>
    #Include <Exceptions/NoRowsException>
    #Include <Exceptions/NotFoundException>
    #Include <Exceptions/ProgrammerException>
    #Include <Exceptions/RequiredFieldException>
    #Include <Exceptions/SQLException>
    #Include <Exceptions/UnexpectedException>
    #Include <Exceptions/ValidationException>

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

    debugException(e, fallbackMessage)
    {
        GLOBAL DEBUG_MODE
        if (DEBUG_MODE) {
            if (!@.handleException(e)) {
                throw e
            }
        } else {
            UI.MsgBox(fallbackMessage, )
        }
    }

    handleException(e)
    {
        if (@.subclassOf(e, "@")) {
            output := ""
            output .= "Exception: `t" e.what "`n"
            output .= "Where: `t`t" e.where "`n`n"
            output .= "Details: `n" e.message
            UI.MsgBox(output, "Exception Occurred")
            return 1
        }
        return 0
    }

    registerExceptionHandler()
    {
        Global
        handleExceptionFunc := ObjBindMethod(this, "handleException")
        OnError(handleExceptionFunc, 1)
    }
}