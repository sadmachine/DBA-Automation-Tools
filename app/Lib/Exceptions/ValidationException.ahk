; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Core.ValidationException
class ValidationException extends Core.ExpectedException
{
    __New(where, message, data := "")
    {
        base.__New("ValidationException", where, message, data)
    }
}