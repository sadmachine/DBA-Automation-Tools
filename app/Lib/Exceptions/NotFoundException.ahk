; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Core.NotFoundException
class NotFoundException extends Core.ExpectedException
{
    __New(where, message, data := "")
    {
        base.__New("NotFoundException", where, message, data)
    }
}