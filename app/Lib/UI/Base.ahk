; === Script Information =======================================================
; Name .........: UI.Base
; Description ..: The Base UI object for all others to extend
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/10/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Base.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/10/2023)
; * Added This Banner
; * Added `actions` and `fields` objects for storing controls
;
; === TO-DOs ===================================================================
; ==============================================================================
class Base extends Gui
{
    ; --- Variables ------------------------------------------------------------

    _width := ""
    _margin := ""
    _color := ""
    _autoSize := false
    _built := false
    actions := {}
    fields := {}

    static _defaultWidth := 240
    static _defaultMargin := 10
    static _defaultColor := {"windowColor": "", "controlColor": ""}

    ; --- Properties -----------------------------------------------------------

    width
    {
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

    margin
    {
        get {
            if (this._margin == "") {
                return this._defaultMargin
            }
            return this._margin
        }
        set {
            local thisLabel := this.label
            this._margin := value
            this.MarginX := this.margin, this.MarginY := this.margin
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
            if (color.Has(key)) {
                return color[key]
            }
            throw new Core.ProgrammerException(A_ThisFunc, "Invalid key for color: " key)
        }
        set {
            local thisLabel := this.label
            if (key == "") {
                if (!IsObject(value)) {
                    throw new Core.ProgrammerException(A_ThisFunc, "You must supply an object (keys: windowColor, controlColor) if you're setting color without a key.")
                }
                this._color := value
            }
            if (!InStr("windowColor controlColor", key)) {
                throw new Core.ProgrammerException(A_ThisFunc, "Key supplied for color should be either ""windowColor"" or ""controlColor""")
            }

            this._color[key] := value

            this.BackColor := this.color["windowColor"]
            return this._color
        }
    }

    defaultOptions
    {
        get {
            return this._defaultOptions
        }

        set {
            this._defaultOptions := value
            return this._defaultOptions
        }
    }

    defaultFont
    {
        get {
            return this._defaultFont
        }

        set {
            this._defaultFont := value
            %thisLabel%.SetFont(this._defaultFont["options"], this._defaultFont["fontName"])
            return this._defaultFont
        }
    }

    defaultWidth
    {
        get {
            return this._defaultWidth
        }

        set {
            this._defaultWidth := value
            return this._defaultWidth
        }
    }

    defaultMargin
    {
        get {
            return this._defaultMargin
        }

        set {
            this._defaultMargin := value
            %thisLabel%.MarginX := this._defaultMargin, %thisLabel%.MarginY := this._defaultMargin
            return this._defaultMargin
        }
    }

    autoSize
    {
        get {
            return this._autoSize
        }
        set {
            this._autoSize := value
            return this._autoSize
        }
    }

    WaitClose()
    {
        WinWaitClose("ahk_id " this.hwnd)
    }

    OwnDialogs()
    {
        this.Opt("+OwnDialogs")
    }

    build()
    {
        this._built := true
    }
}