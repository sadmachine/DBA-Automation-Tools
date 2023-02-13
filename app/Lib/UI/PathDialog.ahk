; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
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

        if (this.pathType = "file") { ; case-insensitive =
            this.defaultFileName := ""
            this.startingPath := ""
            this.filter := ""
            this.dialogOptions := 3 ; file and path must exist, by default
            this.startingFolder := userHome
            if (this.data.HasKey("dialogOptions")) {
                this.dialogOptions := this.data["dialogOptions"]
            }
            if (this.data.HasKey("startingFolder")) {
                this.startingFolder := this.data["rootDir"]
            }
            if (this.data.HasKey("defaultFilename")) {
                this.defaultFileName := this.data["defaultFilename"]
            }
            if (this.data.HasKey("title")) {
                this.title := this.data["title"]
            }
            if (this.data.HasKey("filter")) {
                this.filter := this.data["filter"]
            }

            if (this.startingFolder != "") {
                this.startingPath := this.startingFolder
                if (this.defaultFilename != "") {
                    this.startingPath := RTrim(this.startingFolder, "\/") "\" LTrim(this.defaultFilename, "\/")
                }
            }
        } else {
            this.dialogOptions := ""
            this.startingFolder := userHome
            this.allowUpwardNavigation := true
            this.folderBoundary := ""
            if (this.data.HasKey("dialogOptions")) {
                this.dialogOptions := this.data["dialogOptions"]
            }
            if (this.data.HasKey("startingFolder")) {
                this.startingFolder := this.data["startingFolder"]
            }
            if (this.data.HasKey("allowUpwardNavigation")) {
                this.allowUpdwardNavigation := this.data["allowUpwardNavigation"]
            }
            if (this.data.HasKey("folderBoundary")) {
                this.startingFolder := this.data["folderBoundary"]
            }
            if (this.data.HasKey("title")) {
                this.title := this.data["title"]
            }
            if (this.data.HasKey("filter")) {
                this.filter := this.data["filter"]
            }

            this.startingPath := (this.allowUpwardNavigation ? "*" : "") this.startingFolder

            if (this.folderBoundary != "" && this.allowUpwardNavigation) {
                this.startingPath := RTrim(this.folderBoundary, " ") " " this.startingPath
            }
        }
    }

    prompt()
    {
        if (this.pathType = "file") { ; Case-insensitive '='
            FileSelectFile, path, % this.dialogOptions, % this.startingPath, % this.title, % this.filter
        } else {
            FileSelectFolder, path, % this.startingPath, % this.dialogOptions, % this.title
        }
        canceled := (ErrorLevel == 0) ? false : true
        result := {value: path, canceled: canceled}
        return result
    }
}