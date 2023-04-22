class YunitWindow
{
    __new(instance)
    {
        global YunitWindowTitle, YunitWindowEntries, YunitWindowStatusBar
        Yunit := Gui()
        Yunit.OnEvent("Close", YunitGuiClose)
        Yunit.OnEvent("Size", YunitGuiSize)
        Yunit.SetFont("s16", "Arial")
        this.text := Yunit.Add("Text", "x0 y0 h30 vYunitWindowTitle Center", "Test Results")

        hImageList := IL_Create()
        IL_Add(hImageList,"shell32.dll",132) ;red X
        IL_Add(hImageList,"shell32.dll",78) ;yellow triangle with exclamation mark
        IL_Add(hImageList,"shell32.dll",147) ;green up arrow
        IL_Add(hImageList,"shell32.dll",135) ;two sheets of paper
        this.icons := {fail: "Icon1", issue: "Icon2", pass: "Icon3", detail: "Icon4"}

        Yunit.SetFont("s10")
        this.treeView := Yunit.Add("TreeView", "x10 y30 vYunitWindowEntries ImageList" . hImageList)

        Yunit.SetFont("s8")
        this.statusBar := Yunit.Add("StatusBar", "vYunitWindowStatusBar -Theme BackgroundGreen")
        Yunit.Opt("+Resize +MinSize320x200")
        Yunit.Title := "Yunit Testing"
        Yunit.Show("w500 h400")
        Yunit.Opt("+LastFound")

        this.Categories := Map()
        Return this

        YunitGuiSize(thisGui, MinMax, A_GuiWidth, A_GuiHeight)
        { ; V1toV2: Added bracket
            this.text.Move(, , A_GuiWidth)
            this.treeView.Move(, , (A_GuiWidth - 20), (A_GuiHeight - 60))
            Yunit.Opt("+LastFound")
            DllCall("user32.dll\InvalidateRect", "uInt", WinExist(), "uInt", 0, "uInt", 1)
            Return
        } ; V1toV2: Added bracket before function

        YunitGuiClose(*)
        { ; V1toV2: Added bracket
            ExitApp()
        }
    } ; V1toV2: Added bracket before function

    Update(Category, TestName, Result)
    {
        Yunit.Default()
        If !this.Categories.Has(Category)
            this.AddCategories(Category)
        Parent := this.Categories[Category]
        If IsObject(result)
        {
            hChildNode := this.treeView.Add(TestName, Parent, this.icons.fail)
            outputStr := ""
            outputStr .= "Line #" result.line ": " result.message
            if (result.what != "") {
                outputStr .= "(" result.what ")"
            }
            if (result.extra != "") {
                outputStr .= " -> " result.extra
            }
            this.treeView.Add(outputStr, hChildNode, this.icons.detail)
            this.statusBar.Options("+BackgroundRed")
            key := category
            pos := 1
            while (pos)
            {
                this.treeView.Modify(this.Categories[key], "Expand " . this.icons.issue)
                pos := InStr(key, ".", false, ((VerCompare(A_AhkVersion, "2") < 0) ? 0 : -1)<1 ? ((VerCompare(A_AhkVersion, "2") < 0) ? 0 : -1)-1 : ((VerCompare(A_AhkVersion, "2") < 0) ? 0 : -1), 1)
                key := SubStr(key, 1, pos-1)
            }
            this.treeView.Modify(Parent, "Expand")
        }
        Else
            this.treeView.Add(TestName, Parent, this.icons.pass)
        this.treeView.Modify(this.treeView.GetNext(), "VisFirst") ;// scroll the treeview back to the top
    }

    AddCategories(Categories)
    {
        Parent := 0
        Category := ""
        Categories_Array := StrSplit(Categories, ".")
        for k,v in Categories_Array
        {
            Category .= (Category == "" ? "" : ".") v
            If (!this.Categories.Has(Category))
                this.Categories[Category] := this.treeView.Add(v, Parent, this.icons.pass)
            Parent := this.Categories[Category]
        }
    }
}


