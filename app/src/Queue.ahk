; === Script Information =======================================================
; Name .........: Queue
; Description ..: A class to register queue handler methods
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Queue.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/13/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
class Queue
{
    static registeredHandlers := {}
    static interval := 1000

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