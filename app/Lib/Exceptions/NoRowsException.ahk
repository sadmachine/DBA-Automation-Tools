; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Core.NoRowsException
class NoRowsException extends Core.ExpectedException
{
    __New(where, message, data := "")
    {
        super.__New("NoRowsException", where, message, data)
    }
}