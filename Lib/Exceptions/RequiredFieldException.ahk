; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; @.RequiredFieldException
class RequiredFieldException extends @.ExpectedException
{
    __New(where, message)
    {
        base.__New("RequiredFieldException", where, message)
    }
}