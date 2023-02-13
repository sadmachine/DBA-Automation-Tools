; Views.Installer
class Installer extends UI.Base
{
    __New()
    {
        base.__New("DBA AutoTools Installer")
        this.build()
    }

    build()
    {
        this.Add("Text", "w460", "Installation Location")
        this.Add("Edit", "w400", installationPath)
        this.Add("Button", "w60 Default", )

        base.build()
    }

}