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
; Revision 2 (05/06/2024)
; * First demo complete
; * Update font size to be 16
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
        UI.Base.defaultFont := {options: "s16", fontName: ""}
        UI.Required.strict := true
        UI.InputBoxObj.defaultMargin := 20
        UI.MsgBoxObj.defaultMargin := 20
        UI.InputBoxObj.defaultWidth := 300 
        UI.MsgBoxObj.defaultWidth := 400
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

    getJob(jobIssue)
    {
        this.jobIssue := jobIssue
        this.jobIssue.jobNumber := UI.Required.InputBox("Enter Job #")
        #.log("app").info(A_ThisFunc, "Job #: " this.jobIssue.jobNumber)
    }

    getIssueDetails()
    {
        Loop {
            try {
                this.jobIssue.partNumber := UI.Required.InputBox("Enter Part #")
                #.log("app").info(A_ThisFunc, "Part #: " this.jobIssue.partNumber)
            } catch e {
                if (@.typeOf(e) == @.ValidationException.__Class) {
                    UI.MsgBox(e.message, "Try Again")
                    continue
                }
                throw e
            }
            break
        }

        if (this.jobIssue.needsLotNumber) {
            Loop {
                try {
                    this.jobIssue.lotNumber := UI.Required.InputBox("Enter Lot #")
                    #.log("app").info(A_ThisFunc, "Lot #: " this.jobIssue.lotNumber)
                } catch e {
                    if (@.typeOf(e) == @.ValidationException.__Class) {
                        UI.MsgBox(e.message, "Try Again")
                        continue
                    }
                    throw e
                }
                break
            }
        }

        Loop {
            try {
                this.jobIssue.location := UI.Required.InputBox("Enter Location")
                #.log("app").info(A_ThisFunc, "Location: " this.jobIssue.location)
            } catch e {
                if (@.typeOf(e) == @.ValidationException.__Class) {
                    UI.MsgBox(e.message, "Try Again")
                    continue
                }
                throw e
            }
            break
        }

        Loop {
            try {
                this.jobIssue.quantity := UI.Required.InputBox("Enter Quantity to Issue")
                #.log("app").info(A_ThisFunc, "Quantity: " this.jobIssue.quantity)
            } catch e {
                if (@.typeOf(e) == @.ValidationException.__Class) {
                    UI.MsgBox(e.message, "Try Again")
                    continue
                }
                throw e
            }
            break
        }
    }

    showJobIssuesList()
    {
        jobIssueGui := new Views.JobIssuesList(this.jobIssue.jobNumber)
        return jobIssueGui.show()
    }

    automate()
    {
        BlockInput On
        BlockInput MouseMove

        try {
            this.closeExistingWindows()

            this.openJobsWindow()

            this.selectJob()

            this.openJobIssuesWindow()

            this.normalizeTabFocus()

            this.selectLineIndex()

            this.sortIssueLines()

            this.issueQuantity()

            this.closeExistingWindows()
        } finally {
            BlockInput Off
            BlockInput MouseMoveOff
        }
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
        ControlGet, topHwnd, Hwnd,, % "TdxDBGrid2", % DBA.Windows.JobIssues
        this.topHwnd := topHwnd
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
        downCount := this.jobIssue.lineIndex - 1
        ControlGet, partNumField, Hwnd, , % "TdxDBEdit5", % DBA.Windows.JobIssues
        found := false
        Loop 3 {
        ControlFocus, , % "ahk_id " this.topHwnd
            Send % "{Home}"
            Send % "{PgUp}"
        Loop % downCount {
                ControlFocus, , % "ahk_id " this.topHwnd
            Send % "{Down}"
            }
            ControlGetText, foundPartNum, , % "ahk_id " partNumField
            if (foundPartNum == this.jobIssue.partNumber) {
                found := true
                break
            }
        }
        if (!found) {
            throw new @.WindowException(A_ThisFunc, "Could not properly select the line index to issues to.", {selected: foundPartNum, target: this.jobIssue.partNumber})
        }
        #.log("app").info(A_ThisFunc, "Complete")
    }

    sortIssueLines()
    {
        this.activateJobIssues()
        ControlGet, bottomHwnd, Hwnd,, % "TdxDBGrid1", % DBA.Windows.JobIssues
        ControlFocus ,, % "ahk_id " bottomHwnd
        Send % "{Home}"
        if (this.jobIssue.needsLotNumber) {
            Send % "{End}"
        } else {
            Send % "{Right}"
        }
        Sleep 100
        ControlGetPos, gridX, gridY, gridWidth, gridHeight,, % "ahk_id " bottomHwnd
        adjustedX := gridX+gridWidth
        adjustedY := gridY+gridHeight
        PixelSearch, findX, findY, % gridX, % gridY, % adjustedX, % adjustedY, 0xff8728, 2, % "Fast RGB"
        clickX := findX + 10
        clickY := gridY + 10 

        MouseMove % clickX, % clickY
        Click

        Sleep 100

        try {
            ImageSearch, outX, outY, % gridX, % gridY, % adjustedX, % gridY + 30, % "*5 " #.Path.Concat($["ASSETS_PATH"], "up-arrow.png")
        } catch e {

        }

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

        if (this.jobIssue.needsLotNumber) {
            results := DBA.QueryBuilder
                        .from("itemh")
                        .select("itemloc, lotno, MAX(created) as dt, SUM(itemh.qty) as qty")
                        .groupBy("itemcode, itemloc, lotno")
                        .having(having)
                        .orderBy("lotno, dt, itemloc")
                        .run()
        } else {
            results := DBA.QueryBuilder
                        .from("itemh")
                        .select("itemloc, MAX(created) as dt, SUM(itemh.qty) as qty")
                        .groupBy("itemcode, itemloc")
                        .having(having)
                        .orderBy("itemloc, dt")
                        .run()
        }

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
        ControlGetPos, gridX, gridY, gridWidth, gridHeight, % "TPageControl2", % DBA.Windows.JobIssues
        adjustedX := gridX+gridWidth
        adjustedY := gridY+gridHeight
        oldX := oldY := 0
        downCount := this.selectIssueIndex() - 1
        if (downCount > 0) {
            count := 0
            Loop {
                PixelSearch, firstX, firstY, % gridX, % gridY, % adjustedX, % adjustedY, 0x0078D7, 2, % "Fast RGB" "0078D7"
                Send % "{Down}"
                PixelSearch, secondX, secondY, % gridX, % gridY, % adjustedX, % adjustedY, 0x0078D7, 2, % "Fast RGB" "0078D7"

                if (firstY == secondY) {
                    Send % "{Home}"
                    Send % "{PgUp}"
                    count := 0
                    continue
                }

                count++
                if (count == downCount) {
                    break
                }
            }
        }
        Send % this.jobIssue.quantity
        BlockInput Off
        BlockInput MouseMoveOff
        result := UI.YesNoBox("Please verify the Job Issue is correct.`nSelect 'Yes' to continue, select 'No' to cancel.")
        if (result.value == "Yes") {
            BlockInput On
            BlockInput MouseMove
            this.activateJobIssues()
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

    cleanup()
    {
        this.closeExistingWindows()
    }
}
