; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Config.Scope
class Scope
{
    static GLOBAL := 1
    static LOCAL := 2

    toString(value)
    {
        Switch value
        {
        Case this.GLOBAL:
            return "global"
        Case this.LOCAL:
            return "local"
        }
    }
}