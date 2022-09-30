class Base
{
    title := ""
    guiOptions := ""
    fontSettings := ""


    __New(title := "", guiOptions := "")
    {
        this.title := title
        this.guiOptions := guiOptions
        return this
    }

    setFont(options := "", fontName := "")
    {
        this.fontSettings := {}
        this.fontSettings["options"] := options
        this.fontSettings["fontName"] := fontName
    }

    bind(hwnd, method)
    {
        bindObj := ObjBindMethod(this, method)
        GuiControl, +g, % hwnd, % bindObj
    }
}