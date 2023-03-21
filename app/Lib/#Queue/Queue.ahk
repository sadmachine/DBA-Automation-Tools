; === Script Information =======================================================
; Name .........: Generalized Queue handler
; Description ..: Used for registering and retrieving queue job handlers
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/20/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Queue.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/20/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; #.Queue
class Queue
{
    ; --- Sub-classes ----------------------------------------------------------
    #Include <#Queue/Queue/Job>

    ; --- Instance/Static Variables --------------------------------------------
    static registeredHandlers := {}
    static interval := 1000

    ; --- Methods --------------------------------------------------------------
    registerHandler(priority, handler)
    {
        if (!this.registeredHandlers.hasKey(priority)) {
            this.registeredHandlers[priority] := []
        }
        this.registeredHandlers[priority].push(handler)
    }

    getHandlers()
    {
        return this.registeredHandlers
    }
}