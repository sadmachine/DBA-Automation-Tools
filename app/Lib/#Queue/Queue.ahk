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
; Revision 3 (03/31/2023)
; * Major fixes and logging added
;
; Revision 4 (04/06/2023)
; * Only delete queuejob file if executed successfully (returned true)
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; #.Queue
class Queue
{
    ; --- Sub-classes ----------------------------------------------------------
    #Include <#Queue/Queue/Job>
    #Include <#Queue/Queue/FileDrivers>

    ; --- Instance/Static Variables --------------------------------------------
    static registeredHandlers := {}
    static namespaces := []
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
        this.namespaces.push(handler.getNamespace())
    }

    getHandlers()
    {
        return this.registeredHandlers
    }

    createJob(jobInstance)
    {
        namespace := jobInstance.getNamespace()
        data := jobInstance.create()
        #.log("queue").info(A_ThisFunc, "Creating Job", {namespace: namespace, data: data})

        validData := false

        filepath := this.fileDriver.createFile(namespace, data)
        writtenData := this.fileDriver.readFile(filepath)
        if (!jobInstance.verify(writtenData)) {
            try {
                this.fileDriver.deleteFile(filepath)
            } catch e {
                this.handleException(e) 
            }
            return false
        }

        return true
    }

    getWaitingJobs()
    {
        queueFiles := {}
        for n, namespace in this.namespaces {
            queueFiles[namespace] := this.fileDriver.retrieveFiles(namespace)
        }
        return queueFiles
    }

    executeJobs()
    {
        jobFiles := this.getWaitingJobs()
        for priority, priorityQueue in this.getHandlers() {
            for n, queueHandler in priorityQueue {
                for n, jobFile in jobFiles[queueHandler.getNamespace()] {
                    try {
                        jobData := this.fileDriver.readFile(jobFile)
                        job := new queueHandler()
                        job.setData(jobData)
                        success := job.execute()
                        if (success) {
                            this.fileDriver.deleteFile(jobFile)
                        }
                    } catch e {
                        this.handleException(e)
                    }
                }
            }
        }
    }

    handleException(e)
    {
        if (@.inheritsFrom(e, "ExpectedException")) {
            #.log("queue").warning(e.where, e.what ": " e.message, e.data)
        } else {
            #.log("queue").error(e.where, e.what ": " e.message, e.data)
        }
    }
}