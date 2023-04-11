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
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Actions.ReceivingTransaction
class ReceivingTransaction extends Actions.Base
{
    __New(&receiver)
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
        WinActivate(DBA.Windows.Main)
        ErrorLevel := WinWaitActive(DBA.Windows.Main, , 5) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
        if ErrorLevel
        {
            throw new Core.WindowException(A_ThisFunc, "Main DBA window never bexame active (waited 5 seconds).")
            ExitApp()
        }

        MenuSelect(DBA.Windows.Main, , "Purch", "PO Receipts")
        ErrorLevel := WinWaitActive(DBA.Windows.POReceiptLookup, , 5) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
        if ErrorLevel
        {
            throw new Core.WindowException(A_ThisFunc, "PO Receipt Lookup window never bexame active (waited 5 seconds).")
            ExitApp()
        }

        Send(this.receiver.poNumber)
        Sleep(500)
        Send("{Enter}")

        ErrorLevel := WinWaitActive(DBA.Windows.POReceipts, , 5) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
        if ErrorLevel
        {
            throw new Core.WindowException(A_ThisFunc, "PO Receipts window never became active (waited 5 seconds).")
            ExitApp()
        }

        position := indexNumber - 1
        Loop position
        {
            Send("{Down}")
        }

        Send("{Tab}")
        Sleep(100)
        Send("{Tab}")
    }

    _saveAndExitPoWindow()
    {
        global
        WinActivate(DBA.Windows.POReceipts)
        ErrorLevel := WinWaitActive(DBA.Windows.POReceipts, , 5) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
        if ErrorLevel
        {
            throw new Core.WindowException(A_ThisFunc, "PO Receipts window never became active (waited 5 seconds).")
            ExitApp()
        }
        Sleep(100)
        Send("{Alt Down}u{Alt Up}")
        Sleep(100)

        WinClose(DBA.Windows.POReceipts)
        ErrorLevel := WinWaitClose(DBA.Windows.POReceipts, , 5) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
        if ErrorLevel
        {
            throw new Core.WindowException(A_ThisFunc, "PO Receipts window never closed (waited 5 seconds).")
            MsgBox("PO Receipts never closed, exiting")
            ExitApp()
        }
    }

    _receiveLotInfo()
    {
        global
        WinActivate(DBA.Windows.POReceipts)
        ErrorLevel := WinWaitActive(DBA.Windows.POReceipts, , 5) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
        if ErrorLevel
        {
            throw new Core.WindowException(A_ThisFunc, "PO Receipts window never became active (waited 5 seconds).")
        }
        ControlFocus("TdxDBGrid1", DBA.Windows.POReceipts)
        Send("{Home}")
        Send(this.receiver.lots["current"].quantity)
        Send("{Enter}")
        Send("{End}")
        Send(this.receiver.lots["current"].lotNumber)
        Send("{Shift Down}{Tab}{Shift Up}")
        Send("{Shift Down}{Tab}{Shift Up}")
        this._enterLocation(this.receiver.lots["current"].location)
    }

    _enterLocation(location)
    {
        Loop{
            Send("{Enter}")
            Sleep(100)
            Send("\")
            ErrorLevel := WinWaitActive("FrmPopDrpLocationLook_sub", , 5) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
            if ErrorLevel
            {
                throw new Core.WindowException(A_ThisFunc, "Location submenu never became active (waited 5 seconds).")
            }
            Sleep(200)
            ControlClick("TCheckBox1", "FrmPopDrpLocationLook_sub", , , , "NA")
            Sleep(200)
            ControlSend(location, "TdxButtonEdit1", "FrmPopDrpLocationLook_sub")
            Sleep(100)
            ControlSend("{Enter}", "TdxButtonEdit1", "FrmPopDrpLocationLook_sub")
            Sleep(100)
            ControlSend("{Enter}", "TdxButtonEdit1", "FrmPopDrpLocationLook_sub")
            Sleep(100)
            Send("{Enter}")
            ControlFocus("TdxDBGrid1", DBA.Windows.POReceipts)
            ControlSend("{Enter}", "TdxDBGrid1", DBA.Windows.POReceipts)
            textCheck := ControlGetText("TdxInplaceDBTreeListButtonEdit1", DBA.Windows.POReceipts)
            if (textCheck != location) {
                ControlSetText(locaiton, "TdxInplaceDBTreeListButtonEdit1", DBA.Windows.POReceipts)
                textCheck := ControlGetText("TdxInplaceDBTreeListButtonEdit1", DBA.Windows.POReceipts)
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
        WinActivate(DBA.Windows.POReceipts)
        ErrorLevel := WinWaitActive(DBA.Windows.POReceipts, , 5) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
        if ErrorLevel
        {
            throw new Core.WindowException(A_ThisFunc, "PO Receipts window never became active (waited 5 seconds).")
        }
        ControlFocus("TdxDBGrid1", DBA.Windows.POReceipts)
        Send("{Down}")
    }

    _checkLocation(expected)
    {
        ControlFocus("TdxDBGrid1", DBA.Windows.POReceipts)
        ControlSend("{Home}", "TdxDBGrid1", DBA.Windows.POReceipts)
        ControlSend("{Right}", "TdxDBGrid1", DBA.Windows.POReceipts)
        ControlSend("{Enter}", "TdxDBGrid1", DBA.Windows.POReceipts)
        textCheck := ControlGetText("TdxInplaceDBTreeListButtonEdit1", DBA.Windows.POReceipts)
        ControlSend("{Enter}", "TdxInplaceDBTreeListButtonEdit1", DBA.Windows.POReceipts)
        if (textCheck != expected) {
            return false
        }
        return true
    }
}