class Transaction
{
    __New(receiver)
    {
        Global
        this.receiver := receiver
        generalConfig := new IniConfig("database")
        this.DB := new DBConnection(generalConfig.get("main.dsn"))
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
            this.receiver.RequestCertInfo()
            this.receiver.RequestLocation()

            this.ReceiveLotInfo()

            loopAgain := (UI.YesNoBox("Add another lot/qty?").value == "Yes")
        }

        this.SaveAndExitPOScreen()

        this.LogInformation()
        inspReport := new Receiving.InspectionReport(this.receiver)
    }

    GetLineNumberIndex()
    {
        Global
        lineNumber := this.receiver.lineReceived
        openLines := DB.query("SELECT line FROM podetl WHERE ponum='" this.receiver.poNumber "' AND qty-qtyr>='" this.receiver.GetCurrentLotInfo("quantity") "' AND closed IS NULL ORDER BY line ASC;")
        ; TODO: Error message if empty
        for n, row in openLines.data()
        {
            curLine := Floor(row["LINE"])
            if (lineNumber == curLine)
            {
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
        Send % this.receiver.GetCurrentLotInfo("quantity")
        Send {Enter}
        Send {End}
        Send % this.receiver.GetCurrentLotInfo("number")
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
        ControlSend, TdxButtonEdit1, % this.receiver.GetCurrentLotInfo("location"), % "FrmPopDrpLocationLook_sub"
        Sleep 100
        ControlSend, TdxButtonEdit1, {Enter}, % "FrmPopDrpLocationLook_sub"
        Sleep 100
        ControlSend, TdxButtonEdit1, {Enter}, % "FrmPopDrpLocationLook_sub"
        Sleep 100
        Send {Enter}
    }

    LogInformation()
    {
        global
        Logfile := A_ScriptDir "/data/Receiving Log.csv"
        exists := FileExist(Logfile)
        file := FileOpen(Logfile, "a")
        if (!exists)
        {
            file.WriteLine("Date,Time,PO#,Part#,Lot#,Qty,Location,Inspection#,Has Cert")
        }
        for n, quantity in this.receiver.quantities
        {
            FormatTime, datestr,, MM/dd/yyyy
            FormatTime, timestr,, HH:mm:ss
            inspectionNumber := config.get("inspection.last_number") + 1
            file.WriteLine(datestr "," timestr "," this.receiver.poNumber "," this.receiver.partNumber "," this.receiver.lotNumbers[n] "," this.receiver.quantities[n] "," this.receiver.locations[n] "," inspectionNumber "," this.receiver.hasCert[n])
            config.set("inspection.last_number", inspectionNumber)
        }
        file.Close()
    }
}