; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Core.EnvironmentException
class EnvironmentException extends Core.UnexpectedException
{
    __New(where, message, data := "")
    {
        base.__New("EnvironmentException", where, message, data)
    }
}