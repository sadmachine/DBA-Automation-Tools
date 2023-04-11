; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Core.SQLException
class SQLException extends Core.UnexpectedException
{
    __New(where, message, data := "")
    {
        base.__New("SQLException", where, message, data)
    }
}