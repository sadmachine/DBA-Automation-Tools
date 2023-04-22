; === Script Information =======================================================
; Name .........: Queue Bootstrapping File
; Description ..: Responsible for registering queue handlers
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/16/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Queue.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/16/2023)
; * Added This Banner
; * Add Inspection Report queue handler
;
; Revision 2 (03/27/2023)
; * Use new global var syntax
; * Set file driver, and use new queue handler syntax
;
; Revision 3 (03/31/2023)
; * Add some logging for Queue bootstrapping
;
; Revision 4 (04/06/2023)
; * Add Inspection report jobs to queue
;
; Revision 5 (04/21/2023)
; * Update for ahk v2
; 
; === TO-DOs ===================================================================
; ==============================================================================

Lib.Queue.setFileDriver(Lib.Queue.FileDrivers.Ini(Env["QUEUE_PATH"]))
Lib.log("queue").info(A_ScriptName, "Set File Driver", {queuePath: Env["QUEUE_PATH"]})

Lib.Queue.registerHandler("1", Actions.ReceivingLog)
Lib.Queue.registerHandler("2", Actions.InspectionReport)
Lib.log("queue").info(A_ScriptName, "Finished registering Queue Handlers")