; Config.PathField
class PathField extends Config.BaseField
{
    __New(label, pathType := "file", scope := "", options := "")
    {
        this.pathType := pathType
        this.dialogData := {}
        if (options.hasKey("dialogData")) {
            this.dialogData := this.options["dialogData"]
        }
        this.dialogData["pathType"] := pathType
        base.__New("path", label, scope, options)
    }
}