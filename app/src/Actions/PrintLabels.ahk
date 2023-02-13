; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Actions.PrintLabels
class PrintLabels extends Actions.Base
{
    __New(ByRef receiver)
    {
        receivingLabelsConfig := Config.load("receiving.labels")
        printJobLocation := receivingLabelsConfig.get("printJobs.location")

        ; Name/Check for file existence
        if (!InStr(FileExist(printJobLocation), "D")) {
            throw new @.FilesystemException(A_ThisFunc, "The Print Job location '" printJobLocation " does not exist or is not a valid directory.")
        }

        FormatTime, fileDateTime, , % "yyyy-MM-dd+HH-mm-ss"
        Random, fileRandomNumber, 0, 10000
        filename := Format("{1:s}_{2:i}_{3:s}.csv", fileDateTime, fileRandomNumber, receiver.identification)
        filepath := RTrim(printJobLocation, "/\") "\" LTrim(filename, "/\")
        printJobFile := FileOpen(filepath, "w")

        if (!printJobFile) {
            throw new @.FilesystemException(A_ThisFunc, "The Print Job file '" printJobFile "' could not be created.")
        }

        ; Pull together data to add to csv
        printJobFile.writeLine("partNum,partDescription,lotNum,printQty,label")

        ; Loop over data and put into csv
        for n, lot in receiver.lots {
            printQtyDialog := new UI.NumberDialog("Lot Label Qty", {min: 1, max: 100})
            result := printQtyDialog.prompt("How many labels should be printed for lot # " lot.lotNumber "?")
            printQty := result.value
            labelName := (lot.hasCert == "Yes" ? "Main" : "QA HOLD")
            printJobFile.writeLine(Format("""{:s}"",""{:s}"",""{:s}"",{:i},""{:s}""", receiver.partNumber, receiver.partDescription, lot.lotNumber, printQty, labelName))
        }

        printJobFile.Close(), printJobFile := ""
    }
}