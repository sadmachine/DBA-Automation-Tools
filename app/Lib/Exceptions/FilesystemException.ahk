; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; @.FilesystemException
class FilesystemException extends @.UnexpectedException
{
    __New(where, message, data := "")
    {
        base.__New("FilesystemException", where, message, data)
    }
}