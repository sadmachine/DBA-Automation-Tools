; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Core.ExpectedException
class ExpectedException extends Core.BaseException
{
    __New(what, where, message, data := "")
    {
        base.__New("Expected", what, where, message, data)
    }
}