; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; @.SQLException
class SQLException extends @.UnexpectedException
{
    __New(where, message)
    {
        base.__New("SQLException", where, message)
    }
}