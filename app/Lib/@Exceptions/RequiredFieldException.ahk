; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; @.RequiredFieldException
class RequiredFieldException extends @.ExpectedException
{
    __New(where, field, message, data := "")
    {
        this.field := field
        base.__New("RequiredFieldException", where, message, data)
    }
}