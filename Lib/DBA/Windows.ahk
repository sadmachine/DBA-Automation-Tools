class Windows {
    static Main := "ahk_exe ejsme.exe ahk_class TfrmAppMain"

    getDimensions(winTitle) 
    {
        WinGetPos, x_pos, y_pos, width, height, % winTitle
        return {"x": x_pos, "y": y_pos, "width": width, "height": height}
    }
}