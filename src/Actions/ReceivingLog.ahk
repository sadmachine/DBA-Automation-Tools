; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Actions.ReceivingLog
class ReceivingLog extends Actions.Base
{
    __New(ByRef receiver)
    {
        config := new IniConfig("po_receiving")
        Logfile := A_ScriptDir "/data/Receiving Log.csv"
        exists := FileExist(Logfile)
        file := FileOpen(Logfile, "a")
        if (!exists)
        {
            file.WriteLine("Date,Time,PO#,Part#,Lot#,Qty,Location,Inspection#,Has Cert")
        }
        for n, lot in receiver.lots
        {
            FormatTime, datestr,, MM/dd/yyyy
            FormatTime, timestr,, HH:mm:ss
            inspectionNumber := config.get("inspection.last_number") + 1
            file.WriteLine(datestr "," timestr "," receiver.poNumber "," receiver.partNumber "," lot.lotNumber "," lot.quantity "," lot.location "," lot.inspectionNumber "," lot.hasCert)
            config.set("inspection.last_number", inspectionNumber)
        }
        file.Close()
    }
}