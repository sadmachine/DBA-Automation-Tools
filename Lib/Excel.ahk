class Excel
{

    ; --- Instance Variables ---------------------------------------------------

    _workbook := false
    _filepath := ""
    _visible := false
    _xlApp := false
    _defaultSheet := 1

    ; --- Properties  ----------------------------------------------------------

    visible[]
    {
        get {
            return this._visible
        }
        set {
            this._visible := value
            this._xlApp.visible := this._visible
            return this.isVisible
        }
    }

    filepath[]
    {
        get {
            return this._filepath
        }
        set {
            this._filepath := value
            if (this._workbook && this._xlApp) {
                this._Cleanup()
            }
            this._xlApp := ComObjCreate("Excel.Application")
            this._workbook := this._xlApp.Workbooks.Open(this._filepath)
            return this._filepath
        }
    }

    do[]
    {
        get {
            return this._workbook
        }
    }

    defaultSheet[]
    {
        get {
            return this._defaultSheet
        }
        set {
            this._defaultSheet := value
            return this._defaultSheet
        }
    }

    textBox[textBoxName, sheetName := ""]
    {
        get {
            if (sheetName == "") {
                sheetName := this._defaultSheet
            }
            return this.do.Sheets(sheetName).Shapes(textBoxName).TextFrame.Characters.Text
        }
        set {
            if (sheetName == "") {
                sheetName := this._defaultSheet
            }
            this.do.Sheets(sheetName).Shapes(textBoxName).TextFrame.Characters.Text = value
            return value
        }
    }

    range[rangeRef, sheetName := ""]
    {
        get {
            if (sheetName == "") {
                sheetName := this._defaultSheet
            }
            return this.do.Sheets(sheetName).Range(rangeRef)
        }
    }

    ; --- Meta Methods ---------------------------------------------------------

    __New(filepath, isVisible := false)
    {
        this.filepath := filepath
        this.visible := isVisible
    }

    __Delete()
    {
        this._Cleanup()
    }

    ; --- "Public" Methods -----------------------------------------------------

    Save()
    {
        return this.do.Save()
    }

    Quit()
    {
        return this._Cleanup()
    }

    ; --- "Private" Methods ----------------------------------------------------

    _Cleanup()
    {
        this._workbook.Close()
        this._workbook := false
        this._xlApp.Quit()
        this._xlApp := false
    }
}