; === Script Information =======================================================
; Name .........: Job Issuing Controller
; Description ..: The puppet master of the Job Issuing process
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/14/2024
; OS Version ...: Windows 11
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: JobIssuing.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/14/2024)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Controllers.Receiving
class JobIssuing extends Controllers.Base
{
    jobIssue := {}

    __New()
    {
        this._bootstrap()
    }

    _bootstrap()
    {
        UI.Base.defaultFont := {options: "s12", fontName: ""}
        UI.Base.defaultMargin := 5
        UI.MsgBoxObj.defaultWidth := 320
        if ($["JOB_ISSUES_KEY_DELAY"]) {
            SetKeyDelay % $["JOB_ISSUES_KEY_DELAY"]
        }
        if ($["JOB_ISSUES_WIN_DELAY"]) {
            SetWinDelay % $["JOB_ISSUES_WIN_DELAY"]
        }
        if ($["JOB_ISSUES_MOUSE_DELAY"]) {
            SetMouseDelay % $["JOB_ISSUES_MOUSE_DELAY"]
        }
        if ($["JOB_ISSUES_CONTROL_DELAY"]) {
            SetControlDelay % $["JOB_ISSUES_CONTROL_DELAY"]
        }
        #.log("app").info(A_ThisFunc, "Complete")
    }

    getInputs(jobIssue)
    {
        jobIssue.jobNumber := UI.Required.InputBox("Enter Job #")
        #.log("app").info(A_ThisFunc, "Job #: " jobIssue.jobNumber)

        jobIssue.partNumber := UI.Required.InputBox("Enter Part #")
        #.log("app").info(A_ThisFunc, "Part #: " jobIssue.partNumber)

        if (jobIssue.needsLotNumber) {
            jobIssue.lotNumber := UI.Required.InputBox("Enter Lot #")
            #.log("app").info(A_ThisFunc, "Lot #: " jobIssue.lotNumber)
        }

        jobIssue.location := UI.Required.InputBox("Enter Location")
        #.log("app").info(A_ThisFunc, "Lot #: " jobIssue.lotNumber)

        jobIssue.quantity := UI.Required.InputBox("Enter Quantity to Issue")
        #.log("app").info(A_ThisFunc, "Quantity: " jobIssue.quantity)

        this.jobIssue := jobIssue
    }


    automate()
    {
        this.closeExistingWindows()

        this.openJobsWindow()

        this.selectJob()

        this.openJobIssuesWindow()

        this.normalizeTabFocus()

        this.selectLineIndex()

        this.sortIssueLines()

        this.issueQuantity()

        this.closeExistingWindows()
        ;   1. Open Job Issues
        ;       - Probably do this by opening Jobs, searching for job number, then going to links -> job issues
        ;       - Validate Jobs and Job Issues is closed before opening
        ;   2. Query for line number to select
        ;   3. Select correct line number
        ;   4. Sort issue detail by lot number > location
        ;   5. Select the correct issue line and enter the quantity to issue
        ;   6. Artificially click the "Update" button
        ;   7. Close out of the Job Issues/Jobs screen
    }

    closeExistingWindows()
    {
        if (WinExist(DBA.Windows.Jobs)) {
            WinClose, % DBA.Windows.Jobs
            WinWaitClose, % DBA.Windows.Jobs,, 5
            if ErrorLevel
            {
                throw new @.WindowException(A_ThisFunc, "Jobs window failed to close (waited 5 seconds).")
            }
        }

        if (WinExist(DBA.Windows.JobIssues)) {
            WinClose, % DBA.Windows.JobIssues
            if (WinExist("Warning ahk_class TDlgSaveLoseCanc ahk_exe ejsme.exe")) {
                WinActivate 
                WinWaitClose
            }
            WinWaitClose, % DBA.Windows.JobIssues,, 5
            if ErrorLevel
            {
                throw new @.WindowException(A_ThisFunc, "Job Issues window failed to close (waited 5 seconds).")
            }
        }
        #.log("app").info(A_ThisFunc, "Complete")
    }

    openJobsWindow()
    {
        WinActivate, % DBA.Windows.Main
        WinWaitActive, % DBA.Windows.Main,, 5
        if ErrorLevel
        {
            throw new @.WindowException(A_ThisFunc, "Main DBA window never bexame active (waited 5 seconds).")
        }
        Send !js
        WinWaitActive, % DBA.Windows.Jobs,, 5
        if ErrorLevel
        {
            throw new @.WindowException(A_ThisFunc, "Jobs window never bexame active (waited 5 seconds).")
        }
        WinActivate % DBA.Windows.Jobs
        #.log("app").info(A_ThisFunc, "Complete")
    }

    selectJob()
    {
        Send % this.jobIssue.jobNumber
        Sleep 100
        #.log("app").info(A_ThisFunc, "Complete")
    }

    openJobIssuesWindow()
    {
        Send !lo
        this.activateJobIssues()
        #.log("app").info(A_ThisFunc, "Complete")
    }

    normalizeTabFocus()
    {
        this.activateJobIssues()
        ControlFocus, % "TPageControl1", % DBA.Windows.JobIssues

        Send % "{Tab}"
        #.log("app").info(A_ThisFunc, "Complete")
    }

    selectLineIndex()
    {
        this.activateJobIssues()
        if (IsObject(this.jobIssue.lineNo)) {
            ddlBox := new UI.DropdownDialog("Choose Line Number", {choices: this.jobIssue.lineNo, selected: this.jobIssue.lineNo[1]})
            result := ddlBox.prompt("There are multiple lines with the given part number. Please select the desired line number to issue.")
            if (result.canceled) {
                this.closeExistingWindows()
                throw new @.ValidationException(A_ThisFunc, "You must select a line number to issue to. The program will now exit.")
            }
            downCount := (result.value / 10) - 1
            this.normalizeTabFocus()
        } else {
            downCount := (this.jobIssue.lineNo / 10) - 1
        }
        this.activateJobIssues()
        Send % "{Down " downCount "}"
        #.log("app").info(A_ThisFunc, "Complete")
    }

    sortIssueLines()
    {
        this.activateJobIssues()
        ControlFocus, % "TPageControl2", % DBA.Windows.JobIssues
        ControlGetFocus, focusedControl, % DBA.Windows.JobIssues
        if (focusedControl == "TPageControl2") {
            Send % "{Tab}"
        } else {
            throw new @.WindowException(A_ThisFunc, "Unable to focus on the correct control. Exiting.", {focusedControl: focusedControl, expectedControl: "TPageControl2"})
        }
        ControlGetFocus, focusedControl, % DBA.Windows.JobIssues
        Send % "{Home}"
        if (this.jobIssue.needsLotNumber) {
            Send % "{End}"
        } else {
            Send % "{Right}"
        }
        ControlGetPos, gridX, gridY, gridWidth, gridHeight, % focusedControl, % DBA.Windows.JobIssues
        adjustedX := gridX+gridWidth
        adjustedY := gridY+gridHeight
        PixelSearch, findX, findY, % gridX, % gridY, % adjustedX, % adjustedY, 0xff8728, 2, % "Fast RGB" "FF8728"
        clickX := findX + 10
        clickY := gridY + 10 

        MouseMove % clickX, % clickY
        Click

        Send % "{Home}"
        Send % "{PgUp}"
        #.log("app").info(A_ThisFunc, "Complete")
    }

    selectIssueIndex()
    {
        having := {}
        having["itemh.itemcode="] := this.jobIssue.partNumber
        having["SUM(itemh.qty)>"] := 0.000001
        ; caseStatement := "CASE itemh.itemloc WHEN item.location THEN 1 ELSE 0 END primaryloc"

        ; results := DBA.QueryBuilder
        ;             .from("itemh")
        ;             .select("itemh.itemloc, itemh.lotno, " caseStatement)
        ;             .join("item", "item.location = itemh.itemloc")
        ;             .groupBy("itemh.itemcode, itemh.itemloc, itemh.lotno, primaryloc")
        ;             .having(having)
        ;             .orderBy("itemh.lotno, primaryloc DESC, itemh.itemloc")
        ;             .run()

        results := DBA.QueryBuilder
                    .from("itemh")
                    .select("itemloc, lotno, MAX(created) as dt, SUM(itemh.qty) as qty")
                    .groupBy("itemcode, itemloc, lotno")
                    .having(having)
                    .orderBy("lotno, dt, itemloc")
                    .run()

        Loop
        {
            row := results.row(A_Index)
            if (row == "") {
                break
            }
            if (row["lotno"] == this.jobIssue.lotNumber && row["itemloc"] == this.jobIssue.location) {
                #.log("app").info(A_ThisFunc, "Complete")
                return A_Index
            }
        }
        #.log("app").info(A_ThisFunc, "Complete")
    }

    issueQuantity()
    {
        this.activateJobIssues()
        WinWaitActive, % DBA.Windows.JobIssues,, 5
        if ErrorLevel
        {
            throw new @.WindowException(A_ThisFunc, "Job Issues Window never bexame active (waited 5 seconds).")
        }
        Send % "{Down " this.selectIssueIndex() - 1 " }"
        Send % this.jobIssue.quantity
        result := UI.YesNoBox("Please verify the Job Issue is correct.`n Select 'Yes' to continue, select 'No' to cancel.")
        if (result.value == "Yes") {
            Send % "!u"
        } else {
            UI.MsgBox("The Job Issue transaction will now be canceled. If this was a data error, please try again, or contact the manufacturer for debugging steps.")
            this.closeExistingWindows()
        }
        #.log("app").info(A_ThisFunc, "Complete")
    }

    activateJobIssues()
    {
        WinActivate, % DBA.Windows.JobIssues
        WinWaitActive, % DBA.Windows.JobIssues,, 5
        if ErrorLevel
        {
            throw new @.WindowException(A_ThisFunc, "Job Issues Window never bexame active (waited 5 seconds).")
        }
        #.log("app").info(A_ThisFunc, "Complete")
    }
}
