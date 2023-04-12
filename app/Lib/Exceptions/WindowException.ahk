; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Core.WindowException
class WindowException extends Core.UnexpectedException
{
    __New(where, message, data := "")
    {
        super.__New("WindowException", where, message, data)
    }
}