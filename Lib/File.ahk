class File
{

    ; --- Include any subclasses -----------------------------------------------

    getFullPath(path)
    {
        global
        cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
        VarSetCapacity(buf, cc*(A_IsUnicode?2:1))
        DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
        return buf
    }

    parseDirectory(path)
    {
        SplitPath, path,, dir
        return dir
    }

    parseFilename(path)
    {
        SplitPath, path, filename
        return filename
    }

    parseExtension(path)
    {
        SplitPath, path,,, extension
        return extension
    }

    parseFilenameNoExtension(path)
    {
        SplitPath, path, , , , filenameWithExtension
        return filenameWithExtension
    }

    parseDrive(path)
    {
        SplitPath, path, , , , , drive
        return drive
    }
}