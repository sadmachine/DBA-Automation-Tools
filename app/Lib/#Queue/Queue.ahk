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
; Revision 2 (03/22/2023)
; * Add fileDriver variable/methods
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
    static fileDriver := {}

    ; --- Methods --------------------------------------------------------------
    setFileDriver(fileDriver)
    {
        this.fileDriver := fileDriver
    }

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

    createJob(jobInstance)
    {
        namespace := queueJobClass.getNamespace()
        data := queueJobClass.create()

        this.fileDriver.createFile(namespace, data)
    }

    getWaitingJobs()
    {
        queueFiles := {}
        for namespace, handlers in this.getHandlers() {
            namespace := handler.getNamespace()
            queueFiles[namespace] := this.fileDriver.retrieveFiles(namespace)
        }

        return queueFiles
    }

    executeJobs()
    {
        jobFiles := this.getWaitingJobs()
        for priority, priorityQueue in Queue.getHandlers() {
            for n, queueHandler in priorityQueue {
                for n, jobFile in jobFiles[queueHandler.getNamespace()] {
                    try {
                        jobData := this.fileDriver.readFile(jobFile)
                        job := new queueHandler()
                        job.setData(jobData)
                        job.execute()
                        this.fileDriver.deleteFile(jobFile)
                    } catch e {
                        #.log("queue").error(e.where, e.what ": " e.message, e.data)
                    }
                }
            }
        }
    }
}