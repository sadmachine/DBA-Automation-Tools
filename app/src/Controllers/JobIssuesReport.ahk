; === Script Information =======================================================
; Name .........: Job Issues Report
; Description ..: Handles the Job Issues Report action
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 05/16/2024
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: JobIssuesReport.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (05/16/2024)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Controllers.JobIssuesReport
class JobIssuesReport extends Controllers.Base
{
    jobNumber := ""

    __New()
    {
        this._bootstrap()
    }

    _bootstrap()
    {
        UI.Base.defaultFont := {options: "s16", fontName: ""}
        UI.Required.strict := true
        UI.InputBoxObj.defaultMargin := 20
        UI.MsgBoxObj.defaultMargin := 20
        UI.InputBoxObj.defaultWidth := 300 
        UI.MsgBoxObj.defaultWidth := 400
    }

    getJob()
    {
        this.jobNumber := UI.Required.InputBox("Enter Job #")
        results := DBA.QueryBuilder
            .from("jobs")
            .select("jobstats")
            .where({"jobno=": this.jobNumber})
            .limit(1)
            .run()

        if (results.count() < 1) {
            throw new @.ValidationException(A_ThisFunc, "The Job # you entered does not exist in the database.", {jobNumber: this.jobNumber})
        }
        #.log("app").info(A_ThisFunc, "Job #: " this.jobNumber)
    }  

    gatherData()
    {
        this.results := DBA.QueryBuilder.from("detlentr")
            .select("jobdetl.sortno, detlentr.dateentr, itemh.itemcode, itemh.lotno, detlentr.qty, item.category, unames.lastname || ', ' || unames.firstname AS name")
            .join("itemh", "itemh.uniqforrec=detlentr.unumber")
            .join("item", "item.itemcode=itemh.itemcode")
            .join("jobdetl", "detlentr.jobdetno=jobdetl.jobdetno")
            .join("unames", "unames.unam_uniqno=itemh.itemh_userid")
            .where({"detlentr.jobno=": this.jobNumber, "itemh.types=": "ISSUE"})
            .orderBy("jobdetl.sortno, detlentr.dateentr")
            .run()
    }

    outputToPdf()
    {
        Gui, generating:New, % "+ToolWindow +AlwaysOnTop", % "Generating"
        Gui, generating:Font, S16
        Gui, generating:Add, % "Text",, % "Generating report, please wait..."
        Gui, generating:Show
        reportFileXLSX := this._getReportFile()
        reportFilePDF := StrReplace(reportFileXLSX, "xlsx", "pdf")
        try {
            xlApp := ComObjActive("Excel.Application") ;handle to running application
        } catch {
            xlApp := ComObjCreate("Excel.Application")
        }
        xlApp.Workbooks.Open(reportFileXLSX)
        xlApp.Range("A1").Value := StrReplace(xlApp.Range("A1").Value, "{{jobno}}", this.jobNumber)
        xlApp.Range("A3").Activate

        currentPartNum := -1
        currentTotalQuantity := 0
        for rowNum, row in this.results.data()
        {
            if (currentPartNum == -1) {
                currentPartNum := row["itemcode"]
            }
            if (currentPartNum != row["itemcode"]) {
                xlApp.ActiveCell.Font.Size := xlApp.ActiveCell.Font.Size+2
                xlApp.ActiveCell.Font.Bold := true
                xlApp.ActiveCell.Value := "Total:"
                xlApp.ActiveCell.Offset(0, 1).Activate

                xlApp.ActiveCell.Font.Size := xlApp.ActiveCell.Font.Size+2
                xlApp.ActiveCell.Font.Bold := true
                xlApp.ActiveCell.Value := currentPartNum
                xlApp.ActiveCell.Offset(0, 2).Activate

                xlApp.ActiveCell.Font.Size := xlApp.ActiveCell.Font.Size+2
                xlApp.ActiveCell.Font.Bold := true
                xlApp.ActiveCell.Value := currentTotalQuantity
                xlApp.ActiveCell.Offset(2, (xlApp.ActiveCell.Column - 1) * -1).Activate

                currentTotalQuantity := 0
                currentPartNum := row["itemcode"]
            }
            xlApp.ActiveCell.Value := "'" row["dateentr"]
            xlApp.ActiveCell.Offset(0, 1).Activate

            xlApp.ActiveCell.Value := "'" row["itemcode"]
            xlApp.ActiveCell.Offset(0, 1).Activate

            xlApp.ActiveCell.Value := "'" row["lotno"]
            xlApp.ActiveCell.Offset(0, 1).Activate

            xlApp.ActiveCell.Value := "'" row["qty"]
            xlApp.ActiveCell.Offset(0, 1).Activate

            xlApp.ActiveCell.Value := "'" row["category"]
            xlApp.ActiveCell.Offset(0, 1).Activate

            xlApp.ActiveCell.Value := "'" row["name"]
            xlApp.ActiveCell.Offset(1, (xlApp.ActiveCell.Column - 1) * -1).Activate

            currentTotalQuantity += row["qty"]
        }
        xlApp.ActiveCell.Font.Size := xlApp.ActiveCell.Font.Size+2
        xlApp.ActiveCell.Font.Bold := true
        xlApp.ActiveCell.Value := "Total:"
        xlApp.ActiveCell.Offset(0, 1).Activate

        xlApp.ActiveCell.Font.Size := xlApp.ActiveCell.Font.Size+2
        xlApp.ActiveCell.Font.Bold := true
        xlApp.ActiveCell.Value := currentPartNum
        xlApp.ActiveCell.Offset(0, 2).Activate

        xlApp.ActiveCell.Font.Size := xlApp.ActiveCell.Font.Size+2
        xlApp.ActiveCell.Font.Bold := true
        xlApp.ActiveCell.Value := currentTotalQuantity
        xlApp.ActiveCell.Offset(2, (xlApp.ActiveCell.Column - 1) * -1).Activate


        xlApp.ActiveCell.Offset(3, (xlApp.ActiveCell.Column - 1) * -1).Activate
        xlApp.ActiveCell.Font.Size := xlApp.ActiveCell.Font.Size+2
        xlApp.ActiveCell.Font.Bold := true
        FormatTime genDate, , % "MM/dd/yyyy"
        FormatTime genTime, , % "hh:mmtt"
        xlApp.ActiveCell.Value := "Report Generated On: " genDate " at " genTime
        xlApp.ActiveSheet.ExportAsFixedFormat(0,reportFilePDF)
        while(!FileExist(reportFilePDF)) {
            Sleep 100
        }
        xlApp.ActiveWorkBook.Save()
        xlApp.ActiveWorkBook.Close()
        xlApp.Quit()
        xlApp := ""

        Gui, generating:Destroy
        RunWait % reportFilePDF
    }

    _getReportFile()
    {
        tempDir := new #.Path.Temp("job-issues-report")
        Random, randnum, 0, 10000
        templateFile := #.Path.concat($["TEMPLATES_PATH"], "Job Issues Report Template.xlsx")
        generatedFile := tempDir.concat("generated-" randnum ".xlsx")
        FileCopy % templateFile, % generatedFile, overwrite := 1
        while (!FileExist(generatedFile)) {
            Sleep 100
        }
        return generatedfile
    }
}