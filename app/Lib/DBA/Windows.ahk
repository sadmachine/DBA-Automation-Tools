class Windows {
    static Main := "ahk_exe ejsme.exe ahk_class TfrmAppMain"
    static POReceiptLookup := "ahk_exe ejsme.exe ahk_class TFrmPopDrpPORecLook"
    static POReceipts := "ahk_exe ejsme.exe ahk_class TFrmPOReceipts"

    getDimensions(winTitle) 
    {
        WinGetPos(&x_pos, &y_pos, &width, &height, winTitle)
        return {"x": x_pos, "y": y_pos, "width": width, "height": height}
    }

    send(winTitle, keys, wait:= 5)
    {
        WinActivate(winTitle)
        ErrorLevel := WinWaitActive(winTitle, , wait) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
        if ErrorLevel {
            return false
        }
        Send(keys)
        return true
    }
}