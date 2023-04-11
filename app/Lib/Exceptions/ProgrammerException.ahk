; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Core.ProgrammerException
class ProgrammerException extends Core.UnexpectedException
{
    __New(where, message, data := "")
    {
        base.__New("ProgrammerException", where, message, data)
    }
}