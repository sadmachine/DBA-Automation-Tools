class Base
{
    ; --- Variables ------------------------------------------------------------

    _title := ""
    _options := ""
    _font := ""
    _width := ""
    _margin := ""
    _color := ""
    _hwnd := ""
    _autoSize := false
    _built := false

    static _defaultOptions := ""
    static _defaultFont := {"options": "", "fontName": ""}
    static _defaultWidth := 240
    static _defaultMargin := 10
    static _defaultColor := {"windowColor": "", "controlColor": ""}

    ; --- Properties -----------------------------------------------------------

    title[] {
        get {
            return this._title
        }
        set {
            this._title := value
            return this._title
        }
    }

    options[init := false] {
        get {
            if (this._options == "") {
                return this._defaultOptions
            }
            return this._options
        }
        set {
            local thisHwnd := this.hwnd
            this._options := value
            options := this._options " hwnd" thisHwnd
            if (!init) {
                Gui, %thisHwnd%:%options%
            }
            return this._options
        }
    }

    font[key := ""] {
        get {
            font := this._font
            if (this._font == "") {
                font := this._defaultFont
            }
            if (key == "") {
                return font
            }
            if (font.HasKey(key)) {
                return font[key]
            }
            throw new @.ProgrammerException(A_ThisFunc, "Invalid key for font options: " key)
        }
        set {
            local thisHwnd := this.hwnd
            if (key == "") {
                if (!IsObject(value)) {
                    throw new @.ProgrammerException(A_ThisFunc, "You must supply an object (keys: options, fontName) if you're setting font without a key.")
                }
                this._font := value
                Gui, %thisHwnd%:Font, % this.font["options"], % this.font["fontName"]
                return this._font
            }
            if (!InStr("options fontName", key)) {
                throw new @.ProgrammerException(A_ThisFunc, "Key supplied for Font should be either ""options"" or ""fontName""")
            }

            this._font[key] := value

            Gui, %thisHwnd%:Font, % this.font["options"], % this.font["fontName"]
            return this._font
        }
    }

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
            if (this._margin == "") {
                return this._defaultMargin
            }
            return this._margin
        }
        set {
            local thisHwnd := this.hwnd
            this._margin := value
            Gui, %thisHwnd%:Margin, % this.margin, % this.margin
            return this._margin
        }
    }

    color[key := ""] {
        get {
            color := this._color
            if (this._color == "") {
                color := this._defaultColor
            }
            if (key == "") {
                return color
            }
            if (color.HasKey(key)) {
                return color[key]
            }
            throw new @.ProgrammerException(A_ThisFunc, "Invalid key for color: " key)
        }
        set {
            local thisHwnd := this.hwnd
            if (key == "") {
                if (!IsObject(value)) {
                    throw new @.ProgrammerException(A_ThisFunc, "You must supply an object (keys: windowColor, controlColor) if you're setting color without a key.")
                }
                this._color := value
            }
            if (!InStr("windowColor controlColor", key)) {
                throw new @.ProgrammerException(A_ThisFunc, "Key supplied for color should be either ""windowColor"" or ""controlColor""")
            }

            this._color[key] := value

            Gui, %thisHwnd%:Color, % this.color["windowColor"], % this.color["controlColor"]
            return this._color
        }
    }

    hwnd[] {
        get {
            if (this._hwnd == "") {
                topLevelClass := StrSplit(this.__Class, ".")[2]
                Random, randomNum
                this._hwnd := topLevelClass "" A_TickCount "" randomNum
            }
            return this._hwnd
        }
        set {
            this._hwnd := value
            return this._hwnd
        }
    }

    defaultOptions[] {
        get {
            return this._defaultOptions
        }

        set {
            this._defaultOptions := value
            return this._defaultOptions
        }
    }

    defaultFont[] {
        get {
            return this._defaultFont
        }

        set {
            this._defaultFont := value
            Gui Font, % this._defaultFont["options"], % this._defaultFont["fontName"]
            return this._defaultFont
        }
    }

    defaultWidth[] {
        get {
            return this._defaultWidth
        }

        set {
            this._defaultWidth := value
            return this._defaultWidth
        }
    }

    defaultMargin[] {
        get {
            return this._defaultMargin
        }

        set {
            this._defaultMargin := value
            Gui Margin, % this._defaultMargin, % this._defaultMargin
            return this._defaultMargin
        }
    }

    autoSize[] {
        get {
            return this._autoSize
        }
        set {
            this._autoSize := value
            return this._autoSize
        }
    }

    ; --- Meta Methods ---------------------------------------------------------

    __New(title := "", options := "")
    {
        Global
        local thisHwnd := this.hwnd
        this.title := title
        this.options[true] := options
        thisHwnd := this.hwnd
        Gui, %thisHwnd%:New, % this.options, % this.title
        return this
    }

    __Delete()
    {
        this.Destroy()
    }

    ; --- Methods --------------------------------------------------------------

    Add(ControlType, cOptions := "", text := "")
    {
        global
        local thisHwnd := this.hwnd

        Random, rand
        cHwnd := ControlType "" A_TickCount "" rand
        cOptions .= " hwnd" cHwnd

        Gui %thisHwnd%:Add, % ControlType, % cOptions, % text
        return % %cHwnd%
    }

    Show(options := "", title := -1)
    {
        global
        thisHwnd := this.hwnd
        if (title != -1) {
            this.title := title
        }
        Gui %thisHwnd%:Show, % options, % this.title
    }

    Submit(NoHide := false)
    {
        global
        local thisHwnd := this.hwnd
        if (NoHide) {
            Gui %thisHwnd%:Submit, NoHide
        }
        Gui %thisHwnd%:Submit
    }

    Cancel()
    {
        global
        local thisHwnd := this.hwnd
        Gui %thisHwnd%:Cancel
    }

    Hide()
    {
        global
        local thisHwnd := this.hwnd
        Gui %thisHwnd%:Hide
    }

    Destroy()
    {
        global
        local thisHwnd := this.hwnd
        Gui %thisHwnd%:Destroy
        this._built := false
    }

    Default()
    {
        global
        local thisHwnd := this.hwnd
        Gui %thisHwnd%:Default
    }

    ApplyFont()
    {
        global
        local thisHwnd := this.hwnd
        Gui %thisHwnd%:Font, % this.font["options"], % this.font["fontName"]
    }

    FocusControl(CtrlHwnd)
    {
        Global
        GuiControl, Focus, % CtrlHwnd
    }

    WaitClose()
    {
        WinWaitClose, % this.title
    }

    OwnDialogs()
    {
        local thisHwnd := this.hwnd
        Gui %thisHwnd%: +OwnDialogs
    }

    updateText(ctrlHwnd, newText)
    {
        GuiControl, Text, % %ctrlHwnd%, % newText
    }

    build()
    {
        this._built := true
    }

    bind(ctrlHwnd, method)
    {
        global
        bindObj := ObjBindMethod(this, method)
        GuiControl, +g, % %ctrlHwnd%, % bindObj
    }
}