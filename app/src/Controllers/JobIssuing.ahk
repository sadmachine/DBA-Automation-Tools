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
        #.log("app").info(A_ThisFunc, "Complete")
    }

    getInputs(jobIssue)
    {
        jobIssue.jobNumber := UI.Required.InputBox("Enter Job #")
        this.Validate.jobNumber(jobIssue)
        #.log("app").info(A_ThisFunc, "Job #: " jobIssue.jobNumber)

        jobIssue.partNumber := UI.Required.InputBox("Enter Part #")
        this.Validate.partNumber(jobIssue)
        #.log("app").info(A_ThisFunc, "Part #: " jobIssue.partNumber)

        jobIssue.lotNumber := UI.Required.InputBox("Enter Lot #")
        this.Validate.lotNumber(jobIssue)
        #.log("app").info(A_ThisFunc, "Lot #: " jobIssue.lotNumber)

        jobIssue.location := UI.Required.InputBox("Enter Location")
        this.Validate.location(jobIssue)
        #.log("app").info(A_ThisFunc, "Lot #: " jobIssue.lotNumber)

        jobIssue.quantity := UI.Required.InputBox("Enter Quantity to Issue")
        this.Validate.quantity(jobIssue)
        #.log("app").info(A_ThisFunc, "Quantity: " jobIssue.quantity)

        this.jobIssue := jobIssue
    }


    class Validate 
    {
        jobNumber(jobIssue)
        {
            jobNumber := jobIssue.jobNumber

            results := DBA.QueryBuilder
                .select("jobstats")
                .from("jobs")
                .where("jobno = " jobNumber)
                .limit(1)
                .run()

            jobStatus := results.row(1)["jobstats"]
            
            if (jobStatus != "RELEASED") {
                throw new @.ValidationException(A_ThisFunc, "The Job # you entered does not have status RELEASE, and cannot be issued to.", {jobNumber: jobNumber, jobStatus: jobStatus})
            }
        }

        partNumber(jobIssue)
        {

        }

        lotNumber(jobIssue)
        {

        }
    }
}
