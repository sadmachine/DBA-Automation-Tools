; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Core.FilesystemException
class FilesystemException extends Core.UnexpectedException
{
    __New(where, message, data := "")
    {
        base.__New("FilesystemException", where, message, data)
    }
}