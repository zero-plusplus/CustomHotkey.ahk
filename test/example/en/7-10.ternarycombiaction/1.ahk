#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { condition: { matchMode: "regex", active: { title: "\.(ahk|ahk2|ah2)\b" } }
                              , action: "{Paste} := "
                              , altAction: "{Paste} = " }).on()
