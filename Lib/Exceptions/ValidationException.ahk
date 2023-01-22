; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; @.ValidationException
class ValidationException extends @.ExpectedException
{
    __New(where, message)
    {
        return base.__New("ValidationException", where, message)
    }
}