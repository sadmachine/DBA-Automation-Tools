; Config.PathField
class PathField extends Config.BaseField
{
    __New(label, pathType := "file", scope := "", options := "")
    {
        this.pathType := Str.toLower(pathType)

        super.__New("path", label, scope, options)
    }
}