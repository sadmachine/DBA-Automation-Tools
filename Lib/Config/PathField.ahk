; Config.PathField
class PathField extends Config.BaseField
{
    __New(label, pathType := "file", scope := "", attributes := "")
    {
        this.pathType := String.toLower(pathType)

        base.__New("path", label, scope, attributes)
    }
}