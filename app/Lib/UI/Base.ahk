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
    _label := ""

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

    label[] {
        get {
            if (this._label == "") {
                topLevelClass := StrSplit(this.__Class, ".")[2]
                Random, randomNum
                this._label := topLevelClass "" A_TickCount "" randomNum
            }
            return this._label
        }
        set {
            return this._label
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
            this._options := value " hwnd" this.label
            options := this._options
            if (!init) {
                Gui, %thisLabel%:%options%
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
            local thisLabel := this.label
            if (key == "") {
                if (!IsObject(value)) {
                    throw new @.ProgrammerException(A_ThisFunc, "You must supply an object (keys: options, fontName) if you're setting font without a key.")
                }
                this._font := value
                Gui, %thisLabel%:Font, % this.font["options"], % this.font["fontName"]
                return this._font
            }
            if (!InStr("options fontName", key)) {
                throw new @.ProgrammerException(A_ThisFunc, "Key supplied for Font should be either ""options"" or ""fontName""")
            }

            this._font[key] := value

            Gui, %thisLabel%:Font, % this.font["options"], % this.font["fontName"]
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
            local thisLabel := this.label
            this._margin := value
            Gui, %thisLabel%:Margin, % this.margin, % this.margin
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
            local thisLabel := this.label
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

            Gui, %thisLabel%:Color, % this.color["windowColor"], % this.color["controlColor"]
            return this._color
        }
    }

    hwnd[] {
        get {
            thisLabel := this.label
            thisHwnd := %thisLabel%
            return thisHwnd
        }
        set {
            return this.hwnd
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
        this.Initialize(title, options)
        return this
    }

    __Delete()
    {
        this.Destroy()
    }

    ; --- Methods --------------------------------------------------------------

    Initialize(title := "", options := "")
    {
        global
        local thisLabel := this.label
        this.options[true] := options
        this.title := title
        thisLabel := this.label
        Gui, %thisLabel%:New, % this.options, % this.title
    }

    Add(ControlType, cOptions := "", text := "")
    {
        global
        local thisLabel := this.label

        Random, rand
        cHwnd := ControlType "" A_TickCount "" rand
        cOptions .= " hwnd" cHwnd

        Gui %thisLabel%:Add, % ControlType, % cOptions, % text
        return % %cHwnd%
    }

    Show(options := "", title := -1)
    {
        global
        thisLabel := this.label
        if (title != -1) {
            this.title := title
        }
        Gui %thisLabel%:Show, % options, % this.title
    }

    Submit(NoHide := false)
    {
        global
        local thisLabel := this.label
        if (NoHide) {
            Gui %thisLabel%:Submit, NoHide
        }
        Gui %thisLabel%:Submit
    }

    Cancel()
    {
        global
        local thisLabel := this.label
        Gui %thisLabel%:Cancel
    }

    Hide()
    {
        global
        local thisLabel := this.label
        Gui %thisLabel%:Hide
    }

    Destroy()
    {
        global
        local thisLabel := this.label
        Gui %thisLabel%:Destroy
        this._built := false
    }

    Default()
    {
        global
        local thisLabel := this.label
        Gui %thisLabel%:Default
    }

    ApplyFont()
    {
        global
        local thisLabel := this.label
        Gui %thisLabel%:Font, % this.font["options"], % this.font["fontName"]
    }

    FocusControl(CtrlHwnd)
    {
        Global
        GuiControl, Focus, % CtrlHwnd
    }

    WaitClose()
    {
        WinWaitClose, % "ahk_id " this.hwnd
    }

    OwnDialogs()
    {
        local thisLabel := this.label
        Gui %thisLabel%: +OwnDialogs
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