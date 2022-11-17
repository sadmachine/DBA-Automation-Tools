class String
{
    toUpper(str)
    {
        StringUpper, output, str
        return output
    }

    toTitleCase(str)
    {
        StringUpper, output, str, T
        return output
    }

    toLower(str)
    {
        StringLower, output, str
        return output
    }

    toSlug(str)
    {
        str := String.toLower(str)
        str := RegExReplace(str, "[^a-z0-9 -]+", "")
        str := StrReplace(str, " ", "-")
        return Trim(str, "-")
    }

    toCamelCase(str)
    {
        str := String.toSlug(str)
        parts := StrSplit(str, "-")
        str := parts[1]
        for index, part in parts {
            if (A_Index == 1) {
                Continue
            }
            str .= String.toTitleCase(part)
        }
        return str
    }
}