#Include <String>
class Config
{
    #include <Config/Group>
    #include <Config/BaseField>
    #include <Config/DateField>
    #include <Config/NumberField>
    #include <Config/StringField>
    #include <Config/FileField>

    static groups := {}
    static groupList := []
    static baseConfigLocation := A_ScriptDir "/config"

    setBaseConfigLocation(baseConfigLocation)
    {
        this.baseConfigLocation := baseConfigLocation
    }

    register(group)
    {
        this.groups[group.slug] := group
        this.groupList.push(group)
    }

    initialize()
    {
        if (FileExist(this.baseConfigLocation) != "D") {
            throw Exception("Directory Not Found", -1, "The directory " this.baseConfigLocation " does not exist.")
        }

        for slug, group in this.groups {
            if (!FileExist(this.getConfigPath(slug))) {
                this.createDefaultConfig(slug)
            }
        }
    }

    get(identifier)
    {
        token := this.parseIdentifier(identifier)
        IniRead, iniValue, % this.getConfigPath(token["group"]), % token["section"], % token["field"]
        return iniValue
    }

    set(identifier, value)
    {
        token := this.parseIdentifier(identifier)
        IniWrite, % value, % this.getConfigPath(token["group"]), % token["section"], % token["field"]
    }

    setDefault(identifier)
    {
        token := this.parseIdentifier(identifier)
        value := this.getDefault(identifier)
        IniWrite, % value, % this.getConfigPath(token["group"]), % token["section"], % token["field"]
    }

    getDefault(identifier)
    {
        token := this.parseIdentifier(identifier)
        return this.groups[token["group"]].fields[token["field"]].default
    }

    parseIdentifier(identifier)
    {
        parts := StrSplit(identifier, ".")
        token := {}
        token["group"] := parts[1]
        token["section"] := parts[2]
        token["field"] := parts[3]
        return token
    }

    getConfigPath(groupSlug)
    {
        return this.baseConfigLocation "/" groupSlug ".ini"
    }

    createDefaultConfig(groupSlug)
    {
        configFilename := this.getConfigPath(groupSlug)
        for slug, field in this.groups[groupSlug].fields {
            IniWrite, % field.default, % configFilename, % field.section, % field.slug
        }
    }
}
