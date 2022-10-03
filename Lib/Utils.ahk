ToUpper(string)
{
    StringUpper, output, string
    return output
}

ToTitleCase(string)
{
    StringUpper, output, string, T
    return output
}

ToLower(string)
{
    StringLower, output, string
    return output
}

FullPathFromRelativePath(path)
{
    cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
    VarSetCapacity(buf, cc*(A_IsUnicode?2:1))
    DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
    return buf
}