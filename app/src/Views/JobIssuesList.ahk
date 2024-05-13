; === Script Information =======================================================
; Name .........: Job Issues List View
; Description ..: Shows the "Pick List" for a specific job, used for Job Issues
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 05/10/2024
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: JobIssuesList.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (05/10/2024)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Views.JobIssuesList 
class JobIssuesList extends UI.base
{
    another := false
    jobNumber := ""

    __New(jobNumber)
    {
        this.jobNumber := jobNumber
        base.__New("Job Issues List", "+AlwaysOnTop +ToolWindow")
        this.build()
    }

    build()
    {
        this.font["options"] := "S16"
        this.ApplyFont()
        this.Add("GroupBox", "x8 y0 w601 h282", "Job Lines")
        this.jobLinesLV := this.Add("ListView", "x16 y32 w586 h242 +AltSubmit +LV0x4000", "Line #|Part #|Job Qty|Remaining")
        this.Add("GroupBox", "x8 y288 w601 h274", "Part Locations")
        this.partLocationsLV := this.Add("ListView", "x16 y320 w586 h233 +LV0x4000", "Location|Qty|Lot #")
        this.Add("StatusBar")
        SB_SetParts(100)
        SB_SetText("`t`tJob #:", 1)
        SB_SetText(this.jobNumber, 2)
        this.continueBtn := this.Add("Button", "x8 y568 w289 h34 Default", "&Continue")
        this.cancelBtn := this.Add("Button", "x320 y568 w289 h34", "Cancel")

        this.bind(this.jobLinesLv, "@updatePartLocations")
        this.bind(this.continueBtn, "@another")
        this.bind(this.cancelBtn, "@cancel")

        this.populateJobLines()
    } 

    populateJobLines()
    {
        this.Default()
        this.ListView(this.jobLinesLV)
        LV_Delete()
        results := DBA.QueryBuilder
                    .from("jobdetl")
                    .select("sortno, refid, qty, actqty")
                    .where({"jobno=": this.jobNumber, "inout=": "Input"}) 
                    .run()

        for rowNumber, row in results.data() 
        {
            success := LV_Add(, Floor(row["sortno"]), row["refid"], row["qty"], row["qty"] - row["actqty"])
        }
        Loop % LV_GetCount("Columns")
        {
            LV_ModifyCol(A_Index, "AutoHdr")
        }

        LV_ModifyCol(3, "Right")
        LV_ModifyCol(4, "Right")
    }

    populatePartLocations()
    {
        this.Default()
        this.ListView(this.jobLinesLV)
        rowNumber := LV_GetNext()
        success := LV_GetText(partNumber, rowNumber, 2)
        this.ListView(this.partLocationsLV)
        LV_Delete()
        results := DBA.QueryBuilder
                    .from("item_char_def_hist")
                    .select("start_dt, end_dt")
                    .where({"itemcode=": partNumber, "start_dt": "IS NOT NULL", "end_dt": "IS NULL"})
                    .limit(1)
                    .run()

        needsLotNumber := false
        if (results.count() == 1) {
            needsLotNumber := true
        }

        having := {}
        having["itemh.itemcode="] := partNumber
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

        if (needsLotNumber) {
            results := DBA.QueryBuilder
                        .from("itemh")
                        .select("itemloc, lotno, MAX(created) as dt, SUM(itemh.qty) as qty")
                        .groupBy("itemcode, itemloc, lotno")
                        .having(having)
                        .orderBy("dt DESC")
                        .run()
        } else {
            results := DBA.QueryBuilder
                        .from("itemh")
                        .select("itemloc, MAX(created) as dt, SUM(itemh.qty) as qty")
                        .groupBy("itemcode, itemloc")
                        .having(having)
                        .orderBy("dt DESC")
                        .run()
        }


        for rowNumber, row in results.data() 
        {
            lotNumber := ""
            if (needsLotNumber) {
                lotNumber := row["lotno"]
            }
            success := LV_Add(, row["itemloc"], row["qty"], lotNumber)
        }
        Loop % LV_GetCount("Columns")
        {
            LV_ModifyCol(A_Index, "AutoHdr")
        }

        LV_ModifyCol(2, "Right")
    }

    show()
    {
        base.Show("w618 h630", "Job Issues List")
        this.WaitClose()
        return this.another
    }

    @updatePartLocations(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:="")
    {
        if (GuiEvent == "Normal" || GuiEvent == "DoubleClick") {
            this.populatePartLocations()
        }
    }

    @another()
    {
        this.another := true
        this.Destroy()
    }

    @cancel()
    {
        this.another := false
        this.Destroy()
    }
}