; === Script Information =======================================================
; Name .........: Settings
; Description ..: General Purpose UI for updating/viewing Settings
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/09/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Settings.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/09/2023)
; * Added This Banner
; * Update messaging
; * Set parent Hwnd for dialogs that need it
;
; === TO-DOs ===================================================================
; TODO: Decouple from fields so much
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; UI.Settings
class Settings extends UI.Base
{
    fields := {}
    actions := {}
    currentField := ""
    editedFields := {}

    __New(title)
    {
        options := "+OwnDialogs +AlwaysOnTop"
        base.__New(title, options)
        this.build()
        this.bindActions()
        UI.Base.defaultFont := {options: "s12", fontName: ""}
    }

    build()
    {
        this.Font := {options: "S10", fontName: ""}
        this.ApplyFont()

        this.actions["fieldSelection"] := this.Add("TreeView", "xm ym w200 h322")

        this.Font := {options: "S12", fontName: ""}
        this.ApplyFont()

        this.fields["fieldName"] := this.Add("GroupBox", "x+8 y0 w434 h290 cGreen Section", "")

        this.Add("Text", "xs+8 ys+26 w88 h25 cMaroon +0x200 +Right", "Config Path:")
        this.fields["configPath"] := this.Add("Edit", "x+8 yp+0 w318 h25 +ReadOnly", "")
        this.Add("Text", "xs+8 ys+56 w88 h25 cMaroon +0x200 +Right", "Scope:")
        this.fields["scope"] := this.Add("Edit", "x+8 yp+0 w105 h25 +ReadOnly", "")
        this.Add("Text", "x+20 yp+0 w80 h25 cMaroon +0x200 +Right", "Required:")
        this.fields["required"] := this.Add("Edit", "x+8 yp+0 w105 h25 +ReadOnly", "")

        this.Add("GroupBox", "xs+8 ys+90 w417 h100 cGreen Section", "Field Description")
        this.fields["description"] := this.Add("Edit", "xs+8 ys+20 w403 r3 +Multi +ReadOnly", "")

        this.Add("Text", "xs+0 ys+104 w104 h25 cMaroon +0x200 +Right Section", "Current Value:")
        this.fields["currentValue"] := this.Add("Edit", "x+8 ys+0 w302 h25 +ReadOnly", "")
        this.Add("Text", "xs+0 ys+30 w104 h25 cMaroon +0x200 +Right Section", "Default Value:")
        this.fields["defaultValue"] := this.Add("Edit", "x+8 ys+0 w302 h25 +0x200 +ReadOnly", "")

        this.actions["restoreDefault"] := this.Add("Button", "xs+0 ys+28 w160 h30 Section", "&Restore Default")
        this.actions["editValue"] := this.Add("Button", "x+146 ys+0 w110 h30", "&Edit Value")
        this.actions["restoreAllDefaults"] := this.Add("Button", "xs+0 y296 w160 h30 Section", "Restore &All Defaults")
        this.actions["save"] := this.Add("Button", "x+18 ys+0 w110 h30", "&Save")
        this.actions["cancel"] := this.Add("Button", "x+18 ys+0 w110 h30", "&Cancel")

        UI.TreeViewBuilder.fromConfig(this, Config)

        base.build()
    }

    bindActions()
    {
        for actionSlug, action in this.actions {
            this.bind(action, actionSlug)
        }
    }

    restoreDefault()
    {
        if (this.currentField == "") {
            UI.MsgBox("You must select a field first.", "Warning")
            return
        }
        field := this.currentField

        field.resetDefault()
        this.editedFields[field.slug] := field
    }

    editValue()
    {
        this.OwnDialogs()
        if (this.currentField == "") {
            UI.MsgBox("You must select a field first.", "Warning")
            return
        }
        field := this.currentField
        if (field.scope == Config.Scope.GLOBAL) {
            result := UI.YesNoBox("This field is a global field. Changing it will affect all other users of the program.`n`nAre you sure you wish to continue?`n", "Warning")
            if (result.canceled || result.value == "No") {
                return
            }
        }
        dialog := UI.DialogFactory.fromConfigField(field)
        dialog.parentHwnd := this.hwnd
        result := dialog.prompt()
        if (result.canceled) {
            return
        }
        field.value := result.value
        this.editedFields[field.slug] := field
        this._updateFieldInfo()
    }

    restoreAllDefaults()
    {
        throw new Core.ProgrammerException(A_ThisFunc, "Not yet implemented.")
    }

    save()
    {
        for fieldSlug, field in this.editedFields {
            field.store()
        }
        this.editedFields := {}
    }

    cancel()
    {
        this.Destroy()
    }

    fieldSelection(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:="")
    {
        switch GuiEvent
        {
        Case "DoubleClick", "S":
            ; Open info about the selected field, if it is a field
            treeNodeId := EventInfo
            labelIdentifier := this._buildLabelIdentifier(treeNodeId)
            field := Config.getFieldByLabelIdentifier(labelIdentifier)
            if (IsObject(field)) {
                this.currentField := field
                field.load()
                this._updateFieldInfo()
            }
        }
    }

    _buildLabelIdentifier(treeNodeId)
    {
        this.Default()
        labelIdentifier := ""
        levelCount := 0
        Loop {
            TV_GetText(labelText, treeNodeId)
            labelIdentifier := labelText "." labelIdentifier
            treeNodeId := TV_GetParent(treeNodeId)
            levelCount++
        } Until (treeNodeId == 0)
        if (levelCount < 4) {
            return ""
        }
        return Trim(labelIdentifier, ".")
    }

    _updateFieldInfo()
    {
        field := this.currentField
        this.UpdateText(this.fields["fieldName"], field.label)
        this.UpdateText(this.fields["configPath"], field.path)
        this.UpdateText(this.fields["scope"], Config.Scope.toString(field.scope))
        this.UpdateText(this.fields["required"], (field.required ? "true" : "false"))
        this.UpdateText(this.fields["description"], field.description)
        this.UpdateText(this.fields["currentValue"], field.get())
        this.UpdateText(this.fields["defaultValue"], (field.default != "" ? field.default : "n/a"))
    }
}
