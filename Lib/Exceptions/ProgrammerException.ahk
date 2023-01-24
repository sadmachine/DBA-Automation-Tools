; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; @.ProgrammerException
class ProgrammerException extends @.UnexpectedException
{
    __New(where, message)
    {
        base.__New("ProgrammerException", where, message)
    }
}