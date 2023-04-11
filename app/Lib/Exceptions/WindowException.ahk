; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Core.WindowException
class WindowException extends Core.UnexpectedException
{
    __New(where, message, data := "")
    {
        base.__New("WindowException", where, message, data)
    }
}