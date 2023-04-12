; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Core.ConnectivityException
class ConnectivityException extends Core.UnexpectedException
{
    __New(where, message, data := "")
    {
        super.__New("ConnectivityException", where, message, data)
    }
}