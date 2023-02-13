; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; @.ConnectivityException
class ConnectivityException extends @.UnexpectedException
{
    __New(where, message)
    {
        base.__New("ConnectivityException", where, message)
    }
}