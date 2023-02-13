; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Controllers.Base
class Base
{
    bind(ctrlHwnd, method)
    {
        global
        bindObj := ObjBindMethod(this, method)
        GuiControl, +g, % %ctrlHwnd%, % bindObj
    }
}