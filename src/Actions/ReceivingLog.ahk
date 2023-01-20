; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Actions.ReceivingLog
class ReceivingLog extends Actions.Base
{
    __New(ByRef receiver)
    {
        filepath := Config.get("receiving.log.file.location")
        exists := FileExist(filepath)
        logfile := FileOpen(filepath, "a")
        if (!exists)
        {
            logfile.WriteLine("Date,Time,PO#,Part#,Lot#,Qty,Location,Inspection#,Has Cert")
        }
        for n, lot in receiver.lots
        {
            FormatTime, datestr,, MM/dd/yyyy
            FormatTime, timestr,, HH:mm:ss
            logfile.WriteLine(datestr "," timestr "," receiver.poNumber "," receiver.partNumber "," lot.lotNumber "," lot.quantity "," lot.location "," lot.inspectionNumber "," lot.hasCert)
        }
        logfile.Close()
    }
}