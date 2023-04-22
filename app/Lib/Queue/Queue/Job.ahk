; === Script Information =======================================================
; Name .........: Queue Job
; Description ..: A base class for representing a Queue Job
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/20/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Job.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/20/2023)
; * Added This Banner
;
; Revision 2 (04/19/2023)
; * Update for ahk v2
; 
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Lib.Queue.Job
class Job
{
    data := Map()

    getNamespace()
    {
        parts := StrSplit(this.__class, ".")
        return parts[parts.Count()]
    }

    getData()
    {
        return this.data
    }

    setData(data)
    {
        this.data := data
    }

    create()
    {

    }

    execute()
    {

    }
}