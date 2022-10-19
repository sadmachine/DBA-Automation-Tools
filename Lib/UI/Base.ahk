class Base
{
    title := ""
    guiOptions := ""
    fontSettings := ""
    _width := ""
    _margin := 10
    static _defaultWidth := 240

    static defaultFontSettings := ""
    static defaultGuiOptions := ""

    width[] {
        get {
            if (this._width == "") {
                return this._defaultWidth
            }
            return this._width
        }
        set {
            this._width := value
            return this._width
        }
    }

    margin[] {
        get {
            return this._margin
        }
        set {
            this._margin := value
            return this._margin
        }
    }

    Font[key := ""] {
        get {
            fontSettings := this.fontSettings
            if (this.fontSettings == "") {
                fontSettings := this.defaultFontSettings
            }
            if (key == "") {
                return fontSettings
            }
            if (fontSettings.HasKey(key)) {
                return fontSettings[key]
            }
            throw Exception("Invalid key for font options: " key)
        }
        set {
            if (key == "") {
                if (!IsObject(value)) {
                    throw Exception("You must supply an object(keys: options, fontName) if you're setting font without a key.")
                }
                this.fontSettings := value
                return this.fontSettings
            }
            if (!InStr("options fontName", key)) {
                throw Exception("Key supplied for Font should be either ""options"" or ""fontName""")
            }

            this.fontSettings := value
            return this.fontSettings
        }
    }

    Options[] {
        get {
            return this.guiOptions
        }
        set {
            this.guiOptions := value
            return value
        }
    }

    __New(title := "", guiOptions := "")
    {
        this.title := title
        this.guiOptions := guiOptions
        return this
    }

    bind(hwnd, method)
    {
        bindObj := ObjBindMethod(this, method)
        GuiControl, +g, % hwnd, % bindObj
    }
}