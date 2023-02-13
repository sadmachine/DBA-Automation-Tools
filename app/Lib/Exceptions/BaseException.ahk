; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; @.BaseException
class BaseException
{
    __New(type, what, where, message)
    {
        this.what := what
        this.where := where
        this.message := message
        this.type := type
    }
}