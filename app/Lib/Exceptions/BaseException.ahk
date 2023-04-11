; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Core.BaseException
class BaseException
{
    __New(type, what, where, message, data := "")
    {
        this.what := what
        this.where := where
        this.message := message
        this.type := type
        this.data := ""
    }
}