; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; @.NotFoundException
class NotFoundException extends @.ExpectedException
{
    __New(where, message)
    {
        return base.__New("NotFoundException", "Expected", where, message)
    }
}