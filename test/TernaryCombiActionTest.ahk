#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { condition: { ime: true }, action: "a", altAction: "b" }).on()
new CustomHotkey("RCtrl & 2", { condition: { matchMode: "regex", active: { title: "\.(ahk|ahk2|ah2)\b" } }, action: ":=", altAction: "=" }).on()
