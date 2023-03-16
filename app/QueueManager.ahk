; === Script Information =======================================================
; Name .........: QueueManager
; Description ..: Daemon for running queue jobs
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: QueueManager.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/13/2023)
; * Added This Banner
;
; Revision 2 (03/15/2023)
; * Got basic queue registration and calling working
;
; Revision 3 (03/16/2023)
; * Move registration to bootstrap file
; * Loop over priority array
;
; === TO-DOs ===================================================================
; ==============================================================================
#NoTrayIcon
#Include src/Bootstrap.ahk

for priority, priorityQueue in Queue.getHandlers() {
    MsgBox % priority
    for n, queueHandler in priorityQueue {
        try {
            queueHandler.call()
        } catch e {
            #.log("queue").error(e.where, e.what ": " e.message, e.data)
        }
    }
}

ExitApp