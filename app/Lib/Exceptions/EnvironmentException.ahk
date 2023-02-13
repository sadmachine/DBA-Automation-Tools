; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; @.EnvironmentException
class EnvironmentException extends @.UnexpectedException
{
    __New(where, message)
    {
        base.__New("EnvironmentException", where, message)
    }
}