; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; @.NoRowsException
class NoRowsException extends @.ExpectedException
{
    __New(where, message, data := "")
    {
        base.__New("NoRowsException", where, message, data)
    }
}