; === Script Information =======================================================
; Name .........: View.Installers.Client
; Description ..: A GUI for the client installer
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 03/09/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Client.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (03/09/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Views.Installers.Client
class Client extends Views.Installers.Base
{

    SelectInstallationPath(pageSlug)
    {
        this.AddChild(pageSlug, "", "-Border -SysMenu -Caption +ToolWindow")
        this.children[pageSlug].Add("Text", "w460", "You are installating the Server version of DBA AutoTools. Make sure to install this on a central location that all clients will have access to over the network. Its recommended to install it in the DBA Manufacturing directory in a subfolder, as all DBA Clients need access to that location anyways.")
        this.children[pageSlug].Add("Text", "w460", "Installation Location")
        this.fields["installationPath"] := this.children[pageSlug].Add("Edit", "w380", "")
        this.actions["@browse"] := this.children[pageSlug].Add("Button", "w60 yp-1 x+5", "Browse")
        this.children[pageSlug].show()
    }

    SecondPage(pageSlug)
    {
        this.AddChild(pageSlug, "", "-Border -SysMenu -Caption +ToolWindow")
        this.children[pageSlug].Add("Text", "w460", "Yerp Derp")
        this.children[pageSlug].Add("Text", "w460", "Installation Location")
        this.fields["installationPath"] := this.children[pageSlug].Add("Edit", "w380", "")
        this.actions["@browse"] := this.children[pageSlug].Add("Button", "w60 yp-1 x+5", "Browse")
        this.children[pageSlug].show()
    }
}