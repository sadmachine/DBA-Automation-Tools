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
; Revision 2 (04/19/2023)
; * Update for ahk v2
; 
; === TO-DOs ===================================================================
; ==============================================================================
class Base extends Gui
{
    ; --- Variables ------------------------------------------------------------
    actions := Map()
    fields := Map()
    _dimensions := Map("width", "", "height", "")
    _font := Map("options", "", "fontName", "")

    static _defaultDimensions := Map("width", "480", "height", "320")
    static _defaultFont := Map("options", "s9", "fontName", "Segoe UI")

    dimensions[key?]
    {
        get 
        {
            dimensionsMap := this._dimensions
            if (this._dimensions["width"] == "" && this._dimensions["height"] == "") {
                dimensionsMap := UI.Base.defaultDimensions
            } 
            if (IsSet(key)) {
                if (type(dimensionsMap) == "Object") {
                    if (dimensionsMap.hasOwnProp(key)) {
                        return dimensionsMap.%key%
                    } else {
                        throw Core.ProgrammerException(A_ThisFunc, "Invalid key for dimensions", { key: key })
                    }
                } else {
                    if (dimensionsMap.has(key)) {
                        return dimensionsMap[key]
                    } else {
                        throw Core.ProgrammerException(A_ThisFunc, "Invalid key for dimensions", { key: key })
                    }
                }
            } 
            return dimensionsMap
        }

        set 
        {
            if (IsSet(key)) {
                if (this._dimensions.has(key)) {
                    this._dimensions[key] := value
                } else {
                    throw Core.ProgrammerException(A_ThisFunc, "Invalid key for dimensions", { key: key })
                }
            } 
            this._dimensions := value
        }
    }

    width
    {
        get
        {
            return this.dimensions["width"]
        }
        set
        {
            this.dimensions["width"] := value
        }
    }

    height
    {
        get
        {
            return this.dimensions["height"]
        }
        set
        {
            this.dimensions["height"] := value
        }
    }

    font[key?]
    {
        get 
        {
            fontMap := this._font
            if (this._font["options"] == "" && this._font["fontName"] == "") {
                fontMap := UI.Base.defaultFont
            }
            if (IsSet(key)) {
                if (type(fontMap) == 'Object') {
                    if (fontMap.hasOwnProp(key)) {
                        return fontMap.%key%
                    } else {
                        throw Core.ProgrammerException(A_ThisFunc, "Invalid key for font", { key: key })
                    }
                } else {
                    if (fontMap.has(key)) {
                        return fontMap[key]
                    } else {
                        throw Core.ProgrammerException(A_ThisFunc, "Invalid key for font", { key: key })
                    }
                }
            } 
            return fontMap
        }

        set
        {
            if (IsSet(key)) {
                if (this._font.has(key)) {
                    this._font[key] := value
                } else {
                    throw Core.ProgrammerException(A_ThisFunc, "Invalid key for font", { key: key })
                }
            } 
            this._font := value
        }
    }

    static defaultFont[key?]
    {
        get
        {
            if (IsSet(key)) {
                if (this._defaultFont.has(key)) {
                    return this._defaultFont[key]
                } else {
                    throw Core.ProgrammerException(A_ThisFunc, "Invalid key for defaultFont", { key: key })
                }
            } 
            return this._defaultFont
        }

        set
        {
            if (IsSet(key)) {
                if (this._defaultFont.has(key)) {
                    this._defaultFont[key] := value
                } else {
                    throw Core.ProgrammerException(A_ThisFunc, "Invalid key for defaultFont", { key: key })
                }
            } 
            this._defaultFont := value
        }
    }

    static defaultDimensions[key?]
    {
        get
        {
            if (IsSet(key)) {
                if (this._defaultDimensions.has(key)) {
                    return this._defaultDimensions[key]
                } else {
                    throw Core.ProgrammerException(A_ThisFunc, "Invalid key for defaultDimensions", { key: key })
                }
            } 
            return this._defaultDimensions
        }

        set
        {
            if (IsSet(key)) {
                if (this._defaultDimensions.has(key)) {
                    this._defaultDimensions[key] := value
                } else {
                    throw Core.ProgrammerException(A_ThisFunc, "Invalid key for defaultDimensions", { key: key })
                }
            } 
            this._defaultDimensions := value
        }
    }

    __New(title, options, eventSink?)
    {
        if (IsSet(eventSink)) {
            super.__New(options, title, eventSink)
        } else {
            super.__New(options, title)
        }
    }

    ApplyFont()
    {
        fontMap := this.font
        this.SetFont(this.font["options"], this.font["fontName"])
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