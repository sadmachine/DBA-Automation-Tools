; Config.FileField
class FileField extends Config.BaseField
{

    __New(label, scope := "", options := "")
    {
        base.__New("file", label, scope, options)
    }
}