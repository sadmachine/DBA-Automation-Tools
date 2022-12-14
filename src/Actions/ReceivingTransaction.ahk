class ReceivingTransaction
{
    Call(ByRef receiver)
    {
        Global
        this.receiver := receiver
        indexNumber := this.GetLineNumberIndex()

        this.PreparePOScreen(indexNumber)

        loopAgain := true
        while (loopAgain)
        {
            if (A_Index != 1) {
                Send {Down}
                this.receiver.RequestLotNumber()
                this.receiver.RequestQuantity()
            }
            this.receiver.hasCert.push(UI.Required.YesNoBox("Does lot # " this.receiver.currentLotInfo["number"] " have certification?"))
            this.receiver.locations.push(UI.Required.InputBox("Enter Location"))

            this.ReceiveLotInfo()

            loopAgain := (UI.YesNoBox("Add another lot/qty?").value == "Yes")
        }

        this.SaveAndExitPOScreen()
    }

    GetLineNumberIndex()
    {
        Global
        lineNumber := this.receiver.lineReceived
        records := Models.DBA.podetl.build("ponum='" this.receiver.poNumber "' AND qty-qtyr>='" this.receiver.currentLotInfo["quantity"] "' AND closed IS NULL", "line ASC")
        ; TODO: Error message if empty
        for n, record in records {
            curLine := Floor(record.line)
            if (lineNumber == curLine) {
                return n
            }
        }
    }

    PreparePOScreen(indexNumber)
    {
        global
        WinActivate, % DBA.Windows.Main
        WinWaitActive, % DBA.Windows.Main,, 5
        if ErrorLevel
        {
            MsgBox % "Main window never became active"
        }

        Send {Alt Down}pR{Alt Up}
        WinWaitActive, % DBA.Windows.POReceiptLookup,, 5
        if ErrorLevel
        {
            MsgBox % "PO Receipt Lookup never became active"
        }

        Send % this.receiver.poNumber
        Sleep 500
        Send {Enter}

        WinWaitActive, % DBA.Windows.POReceipts,, 5
        if ErrorLevel
        {
            MsgBox % "PO Receipts never became active"
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

    SaveAndExitPOScreen()
    {
        global
        WinActivate, % DBA.Windows.POReceipts
        WinWaitActive, % DBA.Windows.POReceipts,, 5
        if ErrorLevel
        {
            MsgBox % "PO Receipts never became active, exiting"
            ExitApp
        }
        Sleep 100
        Send {Alt Down}u{Alt Up}
        Sleep 100

        WinClose, % DBA.Windows.POReceipts
        WinWaitClose, % DBA.Windows.POReceipts,, 5
        if ErrorLevel
        {
            MsgBox % "PO Receipts never closed, exiting"
            ExitApp
        }
    }

    ReceiveLotInfo()
    {
        global
        WinActivate, % DBA.Windows.POReceipts
        WinWaitActive, % DBA.Windows.POReceipts,, 5
        if ErrorLevel
        {
            MsgBox % "PO Receipts never became active"
        }
        Send {Home}
        Send % this.receiver.currentLotInfo["quantity"]
        Send {Enter}
        Send {End}
        Send % this.receiver.currentLotInfo["number"]
        Send {Shift Down}{Tab}{Shift Up}
        Send {Shift Down}{Tab}{Shift Up}
        Send {Enter}
        Sleep 100
        Send % "\"
        WinWaitActive, % "FrmPopDrpLocationLook_sub",, 5
        if ErrorLevel
        {
            MsgBox % "Location submenu never became active."
            ExitApp
        }
        Sleep 200
        ControlClick, TCheckBox1, % "FrmPopDrpLocationLook_sub",,,,NA
        Sleep 200
        ControlSend, TdxButtonEdit1, % this.receiver.currentLotInfo["location"], % "FrmPopDrpLocationLook_sub"
        Sleep 100
        ControlSend, TdxButtonEdit1, {Enter}, % "FrmPopDrpLocationLook_sub"
        Sleep 100
        ControlSend, TdxButtonEdit1, {Enter}, % "FrmPopDrpLocationLook_sub"
        Sleep 100
        Send {Enter}
    }
}