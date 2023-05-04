; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; @.ExpectedException
class ExpectedException extends @.BaseException
{
    __New(what, where, message, data := "")
    {
        base.__New("Expected", what, where, message, data)
    }
}