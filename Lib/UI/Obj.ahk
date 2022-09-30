class Obj 
{
    prompt := ""
    title := ""
    gui_options := ""

    __New(prompt, title := "", gui_options := "-Sysmenu +AlwaysOnTop")
    {
        if (title == "") 
        {
            title := prompt
        }

        if (gui_options == "")
        {
            gui_options := ""
        }
    }

    setFont(options := "", font_name := "")
} 