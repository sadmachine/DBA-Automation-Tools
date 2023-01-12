; Config.PathField
class PathField extends Config.BaseField
{
    __New(label, pathType := "file", scope := "", options := "")
    {
        this.pathType := pathType

        base.__New("path", label, scope, options)
    }
}