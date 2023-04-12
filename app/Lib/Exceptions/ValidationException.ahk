; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Core.ValidationException
class ValidationException extends Core.ExpectedException
{
    __New(where, message, data := "")
    {
        super.__New("ValidationException", where, message, data)
    }
}