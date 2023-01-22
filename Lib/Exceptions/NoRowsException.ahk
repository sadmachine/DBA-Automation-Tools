; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; @.NoRowsException
class NoRowsException extends @.ExpectedException
{
    __New(where, message)
    {
        return base.__New("NoRowsException", "Expected", where, message)
    }
}