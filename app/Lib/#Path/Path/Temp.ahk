; === Script Information =======================================================
; Name .........: Path.Temp
; Description ..: Temporary path operations
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/27/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Temp.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/27/2023)
; * Added This Banner
;
; Revision 2 (02/28/2023)
; * Add methods for getting temp paths
;
; Revision 3 (03/05/2023)
; * Cleanup temp directories on exit/error
;
; === TO-DOs ===================================================================
; TODO - Create static list of temp directories to destroy on error/exit
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Path.Temp
class Temp
{
    static initialized := false
    static pathsToClean := []
    namespace := ""
    path := ""

    __New(namespace)
    {
        this.namespace := namespace
        this._initialize()
        this._createNamespace()
    }

    concat(path)
    {
        return #.Path.concat(this.path, path)
    }

    _initialize()
    {
        if (#.Path.Temp.initialized) {
            return
        }
        if (!FileExist(A_Temp)) {
            throw new @.FilesystemException(A_ThisFunc, "The temporary directory, " A_Temp ", did not exist.")
        }

        cleanupMethod := ObjBindMethod(this, "_cleanup")
        OnExit(cleanupMethod, -1)
        OnError(cleanupMethod, -1)

        #.Path.Temp.initialized := true
    }

    _createNamespace()
    {
        namespacePath := #.Path.concat(A_Temp, this.namespace)
        if (FileExist(namespacePath) != "D") {
            FileCreateDir % namespacePath
            if (ErrorLevel) {
                throw new @.FilesystemException(A_ThisFunc, "Failure when attempting to create temporary directory: " namespacePath)
            }
        }
        this.path := namespacePath
        #.Path.Temp.pathsToClean.Push(this.path)
    }

    _cleanup()
    {
        for index, path in #.Path.Temp.pathsToClean {
            FileRemoveDir, % path, 1
        }
        return 0
    }
}