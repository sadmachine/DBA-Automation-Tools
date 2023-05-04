; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; @.NotFoundException
class NotFoundException extends @.ExpectedException
{
    __New(where, message, data := "")
    {
        base.__New("NotFoundException", where, message, data)
    }
}