; === Script Information =======================================================
; Name .........: Print Labels Action
; Description ..: Handles the printing of labels given a receiver model
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: PrintLabels.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/13/2023)
; * Added This Banner
;
; Revision 2 (03/05/2023)
; * Implement temp dir and CMD copy/move
;
; Revision 3 (04/30/2023)
; * Add additional logging
;
; === TO-DOs ===================================================================
; TODO - Decouple from Receiver model
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
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
        tempDir := new #.Path.Temp("DBA AutoTools")
        finalFilepath := #.Path.concat(printJobLocation, filename)
        filepath := tempDir.concat(filename)
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
            outputLine := Format("""{:s}"",""{:s}"",""{:s}"",{:i},""{:s}""", receiver.partNumber, receiver.partDescription, lot.lotNumber, printQty, labelName)
            printJobFile.writeLine(outputLine)
            #.log("app").info(A_ThisFunc, "Created label job file: " outputLine)
        }

        printJobFile.Close()
        printJobFile := ""

        #.Cmd.move(filePath, finalFilepath)
    }
}