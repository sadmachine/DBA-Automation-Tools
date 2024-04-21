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
        
    }
}
