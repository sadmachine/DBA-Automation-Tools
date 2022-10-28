class Transaction
{
    __New(lineNumber, receiver)
    {
        Global
        this.receiver := receiver
        this.DB := new DBConnection()
        indexNumber := this.GetLineNumberIndex(lineNumber)

        lot_numbers := []
        quantities := []
        locations := []
        hasCert := UI.YesNoBox("Does lot # " this.receiver.lotNumbers[this.receiver.currentIndex] " have certification?")
        if (hasCert.value == "Yes") {
            location := "Received"
        } else {
            location := "QA Hold"
        }

        WinActivate, % DBA.Windows.Main
        WinWaitActive, % DBA.Windows.Main,, 5
        if ErrorLevel
        {
            MsgBox % "Main window never became active"
        }

        Send {Alt Down}pr{Alt Up}
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
        this.ReceiveQtyAndLot(this.receiver.quantities[this.receiver.currentIndex], this.receiver.lotNumbers[this.receiver.currentIndex], location)

        locations.push(location)

        anotherLot := UI.YesNoBox("Add another lot/qty?")
        while (anotherLot.value == "Yes")
        {
            this.receiver.RequestLotNumber()
            this.receiver.RequestQuantity()
            this.receiver.currentIndex += 1
            hasCert := UI.YesNoBox("Does lot # " this.receiver.lotNumbers[this.receiver.currentIndex] " have certification?")
            if (hasCert.value == "Yes") {
                location := "Received"
            } else {
                location := "QA Hold"
            }
            WinActivate, % DBA.Windows.POReceipts
            WinWaitActive, % DBA.Windows.POReceipts,, 5
            if ErrorLevel
            {
                MsgBox % "PO Receipts never became active"
            }
            Send {Down}
            this.ReceiveQtyAndLot(this.receiver.quantities[this.receiver.currentIndex], this.receiver.lotNumbers[this.receiver.currentIndex], location)
            locations.push(location)
            anotherLot := UI.YesNoBox("Add another lot/qty?")
        }

        WinActivate, % DBA.Windows.POReceipts
        WinWaitActive, % DBA.Windows.POReceipts,, 5
        if ErrorLevel
        {
            MsgBox % "PO Receipts never became active, exiting"
            ExitApp
        }
        Send {Alt Down}u{Alt Up}

        Logfile := A_ScriptDir "/data/Receiving Log.csv"
        exists := FileExist(Logfile)
        file := FileOpen(Logfile, "a")
        if (!exists)
        {
            file.WriteLine("Date,Time,PO#,Part#,Lot#,Qty,Location,Inspection#")
        }
        for n, quantity in this.receiver.quantities
        {
            FormatTime, datestr,, MM/dd/yyyy
            FormatTime, timestr,, HH:mm:ss
            inspectionNumber := config.get("inspection.last_number") + 1
            file.WriteLine(datestr "," timestr "," this.receiver.poNumber "," this.receiver.partNumber "," this.receiver.lotNumbers[n] "," this.receiver.quantities[n] "," locations[n] "," inspectionNumber)
            config.set("inspection.last_number", inspectionNumber)
        }
        file.Close()

        WinClose, % DBA.Windows.POReceipts
        WinWaitClose, % DBA.Windows.POReceipts,, 5
        if ErrorLevel
        {
            MsgBox % "PO Receipts never closed, exiting"
            ExitApp
        }
    }

    GetLineNumberIndex(lineNumber)
    {
        Global
        openLines := DB.query("SELECT line FROM podetl WHERE ponum='" this.receiver.poNumber "' AND qty-qtyr>='" this.receiver.quantities[this.receiver.currentIndex] "' AND closed IS NULL ORDER BY line ASC;")
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

    ReceiveQtyAndLot(qty, lot_number, location)
    {
        Send {Home}
        Send % qty
        Send {Enter}
        Send {End}
        Send % lot_number
    }
}