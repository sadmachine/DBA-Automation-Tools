class ProgressBoxObj extends UI.Base
{

    _indeterminate := true
    _startValue := ""
    _barFGColor := "Lime"
    _barBGColor := "Silver"
    _currentCount := 0

    __New(displayText, title := "", options := "-SysMenu +AlwaysOnTop")
    {
        this.displayText := displayText
        this.title := (title ? title : displayText)
        base.__New(title, options)
    }

    SetRange(firstVal, secondVal := "")
    {
        this._indeterminate := false

        if (secondVal == "") {
            this._minCount := 0
            this._maxCount := firstVal
        } else {
            this._minCount := firstVal
            this._maxCount := secondVal
        }
    }

    SetStartValue(value)
    {
        this._startValue := value
        this._currentCount := value
    }

    SetBarFGColor(colorVal)
    {
        this._barFGColor := colorVal
    }

    SetBarBGColor(colorVal)
    {
        this._barBGColor := colorVal
    }

    _getRangeOption()
    {
        if (this._indeterminate) {
            return "0x8"
        } else {
            return "range" this._minCount "-" this._maxCount
        }
    }

    _getStartValue()
    {
        return (this._startValue == "" ? this._minCount : this._startValue)
    }

    Show(options := "", title := -1)
    {
        this.ApplyFont()
        this.Add("Text", "Center w280", this.displayText)
        this.ProgressBar := this.Add("Progress", "w280 h20 background" this._barBGColor " c" this._barFGColor " " this._getRangeOption(), 1)
        if (!this._indeterminate) {
            this.ProgressText := this.Add("Text", "Center w280 r1", this._getStartValue() " / " this._maxCount)
        }
        base.Show(options, title)
    }

    Update(progressBarValue, textValue)
    {
        progressBar := this.ProgressBar
        progressText := this.ProgressText
        if (this._indeterminate) {
            GuiControl,, % %progressBar%, +1
        } else {
            GuiControl,, % %progressBar%, % progressBarValue
            GuiControl,, % %progressText%, % textValue " / " this._maxCount
        }
    }

    Increment()
    {
        progressBar := this.ProgressBar
        progressText := this.ProgressText
        if (this._indeterminate) {
            GuiControl,, % %progressBar%, +1
        } else {
            this._currentCount += 1
            if (this._currentCount > this._maxCount) {
                return
            }
            GuiControl,, % %progressBar%, % this._currentCount
            GuiControl,, % %progressText%, % this._currentCount " / " this._maxCount
        }
    }
}