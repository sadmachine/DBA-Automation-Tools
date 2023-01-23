; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; @.RequiredFieldException
class RequiredFieldException extends @.ExpectedException
{
    __New(where, message)
    {
        return base.__New("RequiredFieldException", where, message)
    }
}