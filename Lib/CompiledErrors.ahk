OnError("HandleCompiledErrors", 1)
Global MOCK_COMPILED := 0

DisplayCompiledError(e)
{
    output := ""
    output .= "Exception: `t" e.message "`n"
    output .= "Where: `t`t" e.what "`n`n"
    output .= "Details: `n" e.extra
    UI.MsgBox(output, "Exception Occurred")
    return 1
}

HandleCompiledErrors(e)
{
    Global MOCK_COMPILED
    if (A_IsCompiled || MOCK_COMPILED) {
        return DisplayCompiledError(e)
    }
    return 0
}