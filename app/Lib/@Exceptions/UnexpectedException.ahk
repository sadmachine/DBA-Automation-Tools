; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; @.UnexpectedException
class UnexpectedException extends @.BaseException
{
    __New(what, where, message, data := "")
    {
        base.__New("Unexpected", what, where, message, data)
    }
}