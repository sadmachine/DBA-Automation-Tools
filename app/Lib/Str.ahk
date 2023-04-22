; === Script Information =======================================================
; Name .........: String
; Description ..: String utility class for common string operations
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/10/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Str.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/10/2023)
; * Added This Banner
; * Added getRenderDimensions method
;
; Revision 2 (04/19/2023)
; * Update for ahk v2
; 
; === TO-DOs ===================================================================
; ==============================================================================
class Str
{
    ;-----------------------------------------------------------------------------------------------------------------------
    ; Function: getRenderDimensions
    ; Calculate widht and/or height of text.
    ; Font face, style and number of lines is taken into account
    ;:
    ; <By.majkinetor>
    ;
    ; Parameters:
    ;		pStr	- Text to be measured
    ;		pFont	- Font description in AHK syntax, default size is 10, default font is MS Sans Serif
    ;		pHeight	- Set to true to return height also. False is default.
    ;		pAdd	- Number to add on width and height.
    ;
    ; Returns:
    ;		Text width if pHeight=false. Otherwise, dimension is returned as "width,height"
    ;
    ; Dependencies:
    ;		<ExtractInteger>
    ;
    ; Examples:
    ;		width := GetTextSize("string to be measured", "bold s22, Courier New" )
    ;
    static getRenderDimensions(pStr, pFontOrObj:="", pHeight:=false, pAdd:=0) {
        local height := [], fontFace := Map(), weight, italic, underline, strikeout , nCharSet
        local hdc := DllCall("GetDC", "Uint", 0)
        local hFont, hOldFont
        local resW, resH, SIZE

        if (IsObject(pFontOrObj)) {
            pFont := pFontOrObj.font["options"] . ", " . pFontOrObj.font["fontName"]
        } else {
            pFont := pFontOrObj
        }

        ;parse font
        italic		:= InStr(pFont, "italic")	 ? 1	: 0
        underline	:= InStr(pFont, "underline") ? 1	: 0
        strikeout	:= InStr(pFont, "strikeout") ? 1	: 0
        weight		:= InStr(pFont, "bold")		 ? 700	: 400
        nCharSet    := 0

        ;height
        RegExMatch(pFont, "(?<=[S|s])(\d{1,2})(?=[ ,])", &height)
        if (height[0] = "")
            height := 10

        LogPixels := RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontDPI", "LogPixels")
        Height := -DllCall("MulDiv", "int", height[0], "int", LogPixels, "int", 72)
        ;face
        RegExMatch(pFont, "(?<=,).+", &fontFace)
        if (fontFace[0] != "") {
            fontFace := RegExReplace(fontFace[0], "(^\s*)|(\s*$)")		;trim
        } else {
            fontFace := "MS Sans Serif"
        }

        height := IsObject(height) ? height[0] : height
        fontFace := IsObject(height) ? height[0] : height

        ;create font
        hFont	:= DllCall("CreateFont", "int", height, "int", 0, "int", 0, "int", 0, "int", weight, "Uint", italic, "Uint", underline, "uint", strikeOut, "Uint", nCharSet, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", fontFace)
        hOldFont := DllCall("SelectObject", "Uint", hDC, "Uint", hFont)

        ; VarSetStrCapacity(&SIZE, 16) ; V1toV2: if 'SIZE' is NOT a UTF-16 string, use 'SIZE := Buffer(16)'
        SIZE := Buffer(16, 0x0)
        curW := "0"
        Loop Parse, pStr, "`n"
        {
            DllCall("DrawTextA", "uint", hDC, "str", A_LoopField, "int", StrLen(pStr), "uint", SIZE.ptr, "uint", 0x400)
            resW := this._ExtractInteger(SIZE, 8)
            curW := resW > curW ? resW : curW
        }
        DllCall("DrawTextA", "uint", hDC, "str", pStr, "int", StrLen(pStr), "uint", SIZE.ptr, "uint", 0x400)
        ;clean

        DllCall("SelectObject", "Uint", hDC, "Uint", hOldFont)
        DllCall("DeleteObject", "Uint", hFont)
        DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)

        resW := this._ExtractInteger(SIZE, 8) + pAdd
        resH := this._ExtractInteger(SIZE, 12) + pAdd

        if (pHeight)
            resW := "W" . resW . " H" . resH

        return resW
    }

    static _ExtractInteger(pSource, pOffset := 0, pIsSigned := false, pSize := 4)
    {
        result := 0
        Loop pSize
            val := NumGet(pSource.ptr, pOffset + A_Index-1, "UInt")
            val := val << 8*(A_Index-1)
            result += val
        if (!pIsSigned OR pSize > 4 OR result < 0x80000000)
            return result
        return -(0xFFFFFFFF - result + 1)
    }

    static toUpper(s)
    {
        output := StrUpper(s)
        return output
    }

    static toTitleCase(s)
    {
        output := StrTitle(s)
        return output
    }

    static toLower(s)
    {
        output := StrLower(s)
        return output
    }

    static toSlug(s)
    {
        s := Str.toLower(s)
        s := RegExReplace(s, "[^a-z0-9 -]+", "")
        s := StrReplace(s, " ", "-")
        return Trim(s, "-")
    }

    static toCamelCase(s)
    {
        s := Str.toSlug(s)
        parts := StrSplit(s, "-")
        s := parts[1]
        for index, part in parts {
            if (A_Index == 1) {
                Continue
            }
            s .= Str.toTitleCase(part)
        }
        return s
    }
}