; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Core.ExpectedException
class ExpectedException extends Core.BaseException
{
    __New(what, where, message, data := "")
    {
        super.__New("Expected", what, where, message, data)
    }
}