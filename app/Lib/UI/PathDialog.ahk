; === Script Information =======================================================
; Name .........: Path Dialog
; Description ..: Dialog for asking for path data
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/09/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: PathDialog.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/09/2023)
; * Added This Banner
; * Convenience and UI updates
; * Populate file/folder by default if a value is passed to the dialog
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; UI.PathDialog
class PathDialog extends UI.BaseDialog
{
    define()
    {
        if (!this.data.HasKey("pathType")) {
            throw new @.ProgrammerException(A_ThisFunc, "data.pathType is missing, must be one of ['file', 'folder', 'directory']")
        }
        if (!InStr("file, folder, directory", this.data["pathType"])) {
            throw new @.ProgrammerException(A_ThisFunc, "data.pathType must be one of ['file', 'folder', 'directory']")
        }

        EnvGet, userHome, % "USERPROFILE"
        this.pathType := this.data["pathType"]

        ; Generic option
        if (this.title == "") {
            this.title := this.data.hasKey("title") ? this.data.title : "Select a Folder"
        }

        ; Pathtype specific options
        if (this.pathType = "file") {
            if (this.data.hasKey("value")) {
                this.startingPath := this.data.value
            } else {
                this.defaultFileName := this.data.hasKey("defaultFilename") ? this.data.defaultFilename : ""
                this.startingFolder := this.data.hasKey("startingFolder") ? this.data.startingFolder : userHome
                this.startingPath := ""
                if (this.startingFolder != "") {
                    this.startingPath := this.startingFolder
                    if (this.defaultFilename != "") {
                        this.startingPath := RTrim(this.startingFolder, "\/") "\" LTrim(this.defaultFilename, "\/")
                    }
                }
            }
            this.filter := this.data.hasKey("filter") ? this.data.filter : ""
            this.dialogOptions := this.data.hasKey("dialogOptions") ? this.data.dialogOptions : 3
        } else {
            this.startingPath := this.data.hasKey("value") ? this.data.value : userHome
        }
    }

    SelectFolderEx(StartingFolder := "", Prompt := "", OwnerHwnd := 0, OkBtnLabel := "") {
        Static OsVersion := DllCall("GetVersion", "UChar")
            , IID_IShellItem := 0
            , InitIID := VarSetCapacity(IID_IShellItem, 16, 0)
            & DllCall("Ole32.dll\IIDFromString", "WStr", "{43826d1e-e718-42ee-bc55-a1e261c37bfe}", "Ptr", &IID_IShellItem)
            , Show := A_PtrSize * 3
            , SetOptions := A_PtrSize * 9
            , SetFolder := A_PtrSize * 12
            , SetTitle := A_PtrSize * 17
            , SetOkButtonLabel := A_PtrSize * 18
            , GetResult := A_PtrSize * 20
        SelectedFolder := ""
        If (OsVersion < 6) { ; IFileDialog requires Win Vista+, so revert to FileSelectFolder
            FileSelectFolder, SelectedFolder, *%StartingFolder%, 3, %Prompt%
            Return SelectedFolder
        }
        OwnerHwnd := DllCall("IsWindow", "Ptr", OwnerHwnd, "UInt") ? OwnerHwnd : 0
        If !(FileDialog := ComObjCreate("{DC1C5A9C-E88A-4dde-A5A1-60F82A20AEF7}", "{42f85136-db7e-439c-85f1-e4075d135fc8}"))
            Return ""
        VTBL := NumGet(FileDialog + 0, "UPtr")
        ; FOS_CREATEPROMPT | FOS_NOCHANGEDIR | FOS_PICKFOLDERS
        DllCall(NumGet(VTBL + SetOptions, "UPtr"), "Ptr", FileDialog, "UInt", 0x00002028, "UInt")
        If (StartingFolder <> "")
            If !DllCall("Shell32.dll\SHCreateItemFromParsingName", "WStr", StartingFolder, "Ptr", 0, "Ptr", &IID_IShellItem, "PtrP", FolderItem)
                DllCall(NumGet(VTBL + SetFolder, "UPtr"), "Ptr", FileDialog, "Ptr", FolderItem, "UInt")
        If (Prompt <> "")
            DllCall(NumGet(VTBL + SetTitle, "UPtr"), "Ptr", FileDialog, "WStr", Prompt, "UInt")
        If (OkBtnLabel <> "")
            DllCall(NumGet(VTBL + SetOkButtonLabel, "UPtr"), "Ptr", FileDialog, "WStr", OkBtnLabel, "UInt")
        If !DllCall(NumGet(VTBL + Show, "UPtr"), "Ptr", FileDialog, "Ptr", OwnerHwnd, "UInt") {
            If !DllCall(NumGet(VTBL + GetResult, "UPtr"), "Ptr", FileDialog, "PtrP", ShellItem, "UInt") {
                GetDisplayName := NumGet(NumGet(ShellItem + 0, "UPtr"), A_PtrSize * 5, "UPtr")
                If !DllCall(GetDisplayName, "Ptr", ShellItem, "UInt", 0x80028000, "PtrP", StrPtr) ; SIGDN_DESKTOPABSOLUTEPARSING
                    SelectedFolder := StrGet(StrPtr, "UTF-16"), DllCall("Ole32.dll\CoTaskMemFree", "Ptr", StrPtr)
                ObjRelease(ShellItem)
        } }
        If (FolderItem)
            ObjRelease(FolderItem)
        ObjRelease(FileDialog)
        Return SelectedFolder
    }

    prompt()
    {
        Loop {
            if (this.pathType = "file") {
                FileSelectFile, path, % this.dialogOptions, % this.startingPath, % this.title, % this.filter
                if (InStr(FileExist(path), "D")) {
                    UI.MsgBox("You have selected a folder/directory, please select a file.")
                    Continue
                }
                canceled := (ErrorLevel == 0) ? false : true
                result := {value: path, canceled: canceled}
                return result
            } else {
                path := this.SelectFolderEx(this.startingPath, this.title, this.parentHwnd)
                if (path != "" && !InStr(FileExist(path), "D")) {
                    UI.MsgBox("You have selected a file, please select a folder/directory.")
                    Continue
                }
                if (path == "") {
                    canceled := true
                }
                result := {value: path, canceled: canceled}
                return result
            }
        }

    }
}