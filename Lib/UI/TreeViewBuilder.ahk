; DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; UI.SettingsFactory
class TreeViewBuilder
{
    fromConfig(guiObj, ConfigObj)
    {
        guiObj.Default()
        for groupSlug, group in ConfigObj.groups {
            groupParent := TV_Add(group.Label)
            for fileSlug, file in group.files {
                fileParent := TV_Add(file.label, groupParent)
                for sectionSlug, section in file.sections {
                    sectionParent := TV_Add(section.label, fileParent)
                    for fieldSlug, field in section.fields {
                        TV_Add(field.label, sectionParent)
                    }
                }
            }
        }
    }
}