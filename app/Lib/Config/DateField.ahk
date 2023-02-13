; Config.DateField
class DateField extends Config.BaseField
{

    __New(label, scope := "", options := "")
    {
        base.__New("date", label, scope, options)
    }
}