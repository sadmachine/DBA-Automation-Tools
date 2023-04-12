; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Core.RequiredFieldException
class RequiredFieldException extends Core.ExpectedException
{
    __New(where, field, message, data := "")
    {
        this.field := field
        super.__New("RequiredFieldException", where, message, data)
    }
}