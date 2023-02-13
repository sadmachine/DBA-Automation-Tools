; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Actions.ReceivingTransaction
class ReceivingTransaction extends Actions.Base
{
    __New(ByRef receiver)
    {
        Global
        local location
        this.receiver := receiver
        indexNumber := this._getLineNumberIndex()

        this._preparePoWindow(indexNumber)

        loopAgain := true
        while (loopAgain)
        {
            if (A_Index != 1) {
                this._nextReceiptLine()
                this.receiver.lots.push(new Models.LotInfo())
                this.receiver.lots["current"].lotNumber := UI.Required.InputBox("Enter Lot #")
                this.receiver.lots["current"].quantity := UI.Required.InputBox("Enter Quantity")
            }
            this.receiver.lots["current"].hasCert := UI.Required.YesNoBox("Does lot # " this.receiver.lots["current"].lotNumber " have certification?")
            location := UI.Required.InputBox("Enter Location")

            while (!Models.DBA.Locations.hasOne(location)) {
                UI.MsgBox("The location entered '" location "' was not valid. Please enter another.")
                location := UI.Required.InputBox("Enter Location")
            }

            this.receiver.lots["current"].location := location

            this._receiveLotInfo()

            loopAgain := (UI.YesNoBox("Add another lot/qty?").value == "Yes")
        }

        this._saveAndExitPoWindow()
    }

    _validLocation()
    {
        local results
        results := new Models.DBA.Locations(this.receiver.lots["current"].location)
        return results.exists
    }

    _getLineNumberIndex()
    {
        Global
        lineNumber := this.receiver.lineReceived
        records := Models.DBA.podetl.build("ponum='" this.receiver.poNumber "' AND qty-qtyr>='" this.receiver.lots["current"].quantity "' AND closed IS NULL", "line ASC")
        ; TODO: Error message if empty
        for n, record in records {
            curLine := Floor(record.line)
            if (lineNumber == curLine) {
                return n
            }
        }
    }

    _preparePoWindow(indexNumber)
    {
        global
        WinActivate, % DBA.Windows.Main
        WinWaitActive, % DBA.Windows.Main,, 5
        if ErrorLevel
        {
            throw new @.WindowException(A_ThisFunc, "Main DBA window never bexame active (waited 5 seconds).")
            ExitApp
        }

        Send {Alt Down}pR{Alt Up}
        WinWaitActive, % DBA.Windows.POReceiptLookup,, 5
        if ErrorLevel
        {
            throw new @.WindowException(A_ThisFunc, "PO Receipt Lookup window never bexame active (waited 5 seconds).")
            ExitApp
        }

        Send % this.receiver.poNumber
        Sleep 500
        Send {Enter}

        WinWaitActive, % DBA.Windows.POReceipts,, 5
        if ErrorLevel
        {
            throw new @.WindowException(A_ThisFunc, "PO Receipts window never became active (waited 5 seconds).")
            ExitApp
        }

        position := indexNumber - 1
        Loop % position
        {
            Send {Down}
        }

        Send {Tab}
        Sleep 100
        Send {Tab}
    }

    _saveAndExitPoWindow()
    {
        global
        WinActivate, % DBA.Windows.POReceipts
        WinWaitActive, % DBA.Windows.POReceipts,, 5
        if ErrorLevel
        {
            throw new @.WindowException(A_ThisFunc, "PO Receipts window never became active (waited 5 seconds).")
            ExitApp
        }
        Sleep 100
        Send {Alt Down}u{Alt Up}
        Sleep 100

        WinClose, % DBA.Windows.POReceipts
        WinWaitClose, % DBA.Windows.POReceipts,, 5
        if ErrorLevel
        {
            throw new @.WindowException(A_ThisFunc, "PO Receipts window never closed (waited 5 seconds).")
            MsgBox % "PO Receipts never closed, exiting"
            ExitApp
        }
    }

    _receiveLotInfo()
    {
        global
        WinActivate, % DBA.Windows.POReceipts
        WinWaitActive, % DBA.Windows.POReceipts,, 5
        if ErrorLevel
        {
            throw new @.WindowException(A_ThisFunc, "PO Receipts window never became active (waited 5 seconds).")
        }
        ControlFocus, % "TdxDBGrid1", % DBA.Windows.POReceipts
        Send {Home}
        Send % this.receiver.lots["current"].quantity
        Send {Enter}
        Send {End}
        Send % this.receiver.lots["current"].lotNumber
        Send {Shift Down}{Tab}{Shift Up}
        Send {Shift Down}{Tab}{Shift Up}
        Send {Enter}
        Sleep 100
        Send % "\"
        WinWaitActive, % "FrmPopDrpLocationLook_sub",, 5
        if ErrorLevel
        {
            throw new @.WindowException(A_ThisFunc, "Location submenu never became active (waited 5 seconds).")
        }
        Sleep 200
        ControlClick, TCheckBox1, % "FrmPopDrpLocationLook_sub",,,,NA
        Sleep 200
        ControlSend, TdxButtonEdit1, % this.receiver.lots["current"].location, % "FrmPopDrpLocationLook_sub"
        Sleep 100
        ControlSend, TdxButtonEdit1, {Enter}, % "FrmPopDrpLocationLook_sub"
        Sleep 100
        ControlSend, TdxButtonEdit1, {Enter}, % "FrmPopDrpLocationLook_sub"
        Sleep 100
        Send {Enter}
    }

    _nextReceiptLine()
    {
        WinActivate, % DBA.Windows.POReceipts
        WinWaitActive, % DBA.Windows.POReceipts,, 5
        if ErrorLevel
        {
            throw new @.WindowException(A_ThisFunc, "PO Receipts window never became active (waited 5 seconds).")
        }
        ControlFocus, % "TdxDBGrid1", % DBA.Windows.POReceipts
        Send {Down}
    }
}