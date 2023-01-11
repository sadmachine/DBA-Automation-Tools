; Config.PathField
class PathField extends Config.BaseField
{
    __New(label, pathType := "file", scope := "", options := "")
    {
        this.pathType := pathType
        if (options.hasKey("dialogData")) {
            this.dialogData := this.options["dialogData"]
        }
        base.__New("path", label, scope, options)
    }
}