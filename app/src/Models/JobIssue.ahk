; === Script Information =======================================================
; Name .........: Job Issue Model
; Description ..: Contains all the data required to perform a job issue
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/14/2024
; OS Version ...: Windows 11
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: JobIssue.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/14/2024)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Models.JobIssue
class JobIssue 
{
    jobNumber := ""
    partNumber := ""
    lotNumber := ""
    location := ""
    quantity := ""
}