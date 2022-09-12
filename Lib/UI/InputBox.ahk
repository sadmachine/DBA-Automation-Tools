class InputBox
{
    __New(label, prompt, title := "", options := "")
    {
        if (title == "") 
        {
            title := prompt
        }
        Gui, %label%:New, % options, % title
        Gui, %label%:Add, Text, % UI.Utils.opts({r: "1"}), % prompt
        Gui, %label%:Add, Edit, % UI.Utils.opts({r: "1"}) 
        Gui, %label%:Add, Button, % UI.Utils.opts({g: "h: "20", default: ""}), Submit
    }
}