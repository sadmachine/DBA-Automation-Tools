; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Actions.PrintLabels
class PrintLabels extends Actions.Base
{
    __New(ByRef Receiver)
    {
        receivingLabelsConfig := Config.load("receiving.labels")
        printJobLocation := receivingLabelsConfig.get("printJobs.location")

        ; Name/Check for file existence
        if (!InStr(FileExist(printJobLocation), "D")) {
            throw new @.FilesystemException(A_ThisFunc, "The Print Job location '" printJobLocation " does not exist or is not a valid directory.")
        }

        FormatTime, fileDateTime,
        Random, fileRandomNumber, 0, 10000
        filename := Format("{1:i}_{2:i}_{3:s}.csv", fileDateTime, fileRandomNumber, receiver.identification)
        filepath := RTrim(printJobLocation, "/\") "\" LTrim(filename, "/\")
        printJobFile := FileOpen(filepath, "w")

        if (!printJobFile) {
            throw new @.FilesystemException(A_ThisFunc, "The Print Job file '" printJobFile "' could not be created.")
        }

        ; Pull together data to add to csv
        printJobFile.writeLine("partNum,lotNum,printQty,waterMark")

        ; Loop over data and put into csv
        for n, lot in receiver.lots {
            printQtyDialog := UI.NumberDialog("Lot Label Qty")
            result := printQtyDialog.prompt("How many labels should be printed for lot # " lot.lotNumber "?")
            printQty := result.value
            waterMark := (lot.hasCert == "Yes" ? "" : "QA HOLD")
            printJobFile.writeLine(Format("{:i},""{:s}"",{:i},""{:s}""", receiver.partNumber, lot.lotNumber, printQty, waterMark))
        }

        printJobFile.Close(), printJobFile := ""
    }
}