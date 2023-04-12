; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Core.UnexpectedException
class UnexpectedException extends Core.BaseException
{
    __New(what, where, message, data := "")
    {
        super.__New("Unexpected", what, where, message, data)
    }
}