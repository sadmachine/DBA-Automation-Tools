; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; @.WindowException
class WindowException extends @.UnexpectedException
{
    __New(where, message)
    {
        return base.__New("WindowException", where, message)
    }
}