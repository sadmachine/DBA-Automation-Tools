; Config.DateField
class DateField extends Config.BaseField
{

    __New(label, scope := "", attributes := "")
    {
        base.__New("date", label, scope, attributes)
    }
}