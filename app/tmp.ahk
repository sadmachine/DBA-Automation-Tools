#Include src/Autoload.ahk

data := {hello: ["test", 1, 0.5], 2: "yippee", "yarg": {fast: "paced", lifestyle: "is dangerous"}}

MsgBox % #.Logger._prepareData(data)