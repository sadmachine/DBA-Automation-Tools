; === Script Information =======================================================
; Name .........: Receiving Transaction Action
; Description ..: Performs a Receiving Transaction in DBA
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: ReceivingTransaction.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; Revision 2 (04/06/2023)
; * Add in checks to validate the location was entered correctly for each lot
;
; Revision 3 (04/30/2023)
; * Add additional logging
;
; Revision 4 (05/18/2023)
; * Properly get the index number for the given line no
; * Still check for closed status on index
;
; === TO-DOs ===================================================================
; ==============================================================================
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
        #.log("app").info(A_ThisFunc, "Line #: " indexNumber)

        this._preparePoWindow(indexNumber)
        #.log("app").info(A_ThisFunc, "PO Window prepared")

        loopAgain := true
        while (loopAgain)
        {
            if (A_Index != 1) {
                this._nextReceiptLine()
                this.receiver.lots.push(new Models.LotInfo())
                this.receiver.lots["current"].lotNumber := UI.Required.InputBox("Enter Lot #")
                #.log("app").info(A_ThisFunc, "Added Lot #: " this.receiver.lots["current"].lotNumber)
                this.receiver.lots["current"].quantity := UI.Required.InputBox("Enter Quantity")
                #.log("app").info(A_ThisFunc, "Added Quantity to Lot # " this.receiver.lots["current"].lotNumber ": " this.receiver.lots["current"].quantity)
            }
            this.receiver.lots["current"].hasCert := UI.Required.YesNoBox("Does lot # " this.receiver.lots["current"].lotNumber " have certification?")
            #.log("app").info(A_ThisFunc, "Lot # " this.receiver.lots["current"].lotNumber " has Cert: " this.receiver.lots["current"].hasCert)
            location := UI.Required.InputBox("Enter Location")

            while (!Models.DBA.Locations.hasOne(location)) {
                UI.MsgBox("The location entered '" location "' was not valid. Please enter another.")
                location := UI.Required.InputBox("Enter Location")
            }

            this.receiver.lots["current"].location := location
            #.log("app").info(A_ThisFunc, "Added location for Lot # " this.receiver.lots["current"].lotNumber ": " this.receiver.lots["current"].location)

            this._receiveLotInfo()

            loopAgain := (UI.YesNoBox("Add another lot/qty?").value == "Yes")
            #.log("app").info(A_ThisFunc, "Another lot/qty requested.")
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
        records := Models.DBA.podetl.build("ponum='" this.receiver.poNumber "' AND (closed='F' OR closed='' OR closed IS NULL)", "line ASC")
        ; TODO: Error message if empty
        for n, record in records {
            curLine := Floor(record.line)
            if (lineNumber == curLine) {
                this.receiver.finalReceipt := record.finalDeli
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

        WinMenuSelectItem, % DBA.Windows.Main,, % "Purch", % "PO Receipts"
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

        if (this.receiver.finalReceipt == "T") {
            MsgBox, 0x1001, % "Final Receipt", % "'Final Receipt' is checked for the current line.`n`nIf you would still like to receive against this line, please uncheck the 'Final Receipt' checkbox and click 'Ok' to continue.`n`nIf you would like to quit the process and receive on another line, please click 'Cancel'"
            IfMsgBox Cancel
                ExitApp
        }
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
        this._enterLocation(this.receiver.lots["current"].location)
    }

    _enterLocation(location)
    {
        Loop {
            oldTitleMatchMode := A_TitleMatchMode
            SetTitleMatchMode, 2
            Send {Enter}
            Sleep 100
            Send % "\"
            WinWaitActive, % "FrmPopDrpLocationLook",, 5
            if ErrorLevel
            {
                throw new @.WindowException(A_ThisFunc, "Location submenu never became active (waited 5 seconds).")
            }
            Sleep 200
            ControlClick, TCheckBox1, % "FrmPopDrpLocationLook",,,,NA
            Sleep 200
            ControlSend, TdxButtonEdit1, % location, % "FrmPopDrpLocationLook"
            Sleep 100
            ControlSend, TdxButtonEdit1, {Enter}, % "FrmPopDrpLocationLook"
            Sleep 100
            ControlSend, TdxButtonEdit1, {Enter}, % "FrmPopDrpLocationLook"
            Sleep 100
            Send {Enter}
            ControlFocus, % "TdxDBGrid1", % DBA.Windows.POReceipts
            ControlSend, TdxDBGrid1, {Enter}, % DBA.Windows.POReceipts
            ControlGetText textCheck, TdxInplaceDBTreeListButtonEdit1, % DBA.Windows.POReceipts
            if (textCheck != location) {
                ControlSetText, TdxInplaceDBTreeListButtonEdit1, % locaiton, % DBA.Windows.POReceipts
                ControlGetText textCheck, TdxInplaceDBTreeListButtonEdit1, % DBA.Windows.POReceipts
                if (textCheck == location) {
                    break
                }
            } else {
                break
            }
        } Until (this._checkLocation(location))
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

    _checkLocation(expected)
    {
        ControlFocus, % "TdxDBGrid1", % DBA.Windows.POReceipts
        ControlSend, TdxDBGrid1, {Home}, % DBA.Windows.POReceipts
        ControlSend, TdxDBGrid1, {Right}, % DBA.Windows.POReceipts
        ControlSend, TdxDBGrid1, {Enter}, % DBA.Windows.POReceipts
        ControlGetText textCheck, TdxInplaceDBTreeListButtonEdit1, % DBA.Windows.POReceipts
        ControlSend, TdxInplaceDBTreeListButtonEdit1, {Enter}, % DBA.Windows.POReceipts
        if (textCheck != expected) {
            return false
        }
        return true
    }
}