; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; @.UnexpectedException
class UnexpectedException extends @.BaseException
{
    __New(what, where, message)
    {
        return base.__New("Unexpected", what, where, message)
    }
}