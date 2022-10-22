#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true
CustomHotkey.debugOptions.enableConditionLog := true

copy := [ { async: "{ToolTip|0.5s}copy" }, "^c" ]
allCopy := [ { async: "{ToolTip|0.5s}all copy" }, "^a^c" ]

hotkeys := new CustomHotkey.Template({ mouseTimeIdle: "250ms" }).on()
hotkeys.add("v", { single: "^v", long: "^a^v" })
hotkeys.add("c", { single: copy, long: allCopy })
hotkeys.add("x", { single: [ { async: "{ToolTip|0.5s}cut" }, "^x" ], double: [ { async: "{ToolTip|0.5s}all cut" }, "^a^x" ] })
hotkeys.on()
