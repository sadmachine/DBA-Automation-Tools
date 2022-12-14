; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Actions.Base
class Base
{
    __Call(method, args*) {
        if (method = "")
            return this.Call(args*)
        if (IsObject(method))
            return this.Call(method, args*)
    }
}