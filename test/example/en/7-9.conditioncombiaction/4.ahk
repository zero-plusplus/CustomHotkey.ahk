#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", [ { condition: false, action: "{Run|R}https://www.google.com/search?q={{SelectedText}:P}" }
                              , { condition: { matchMode: "regex", active: { title: "\.(js|ts)" } }, action: "{Run|R}https://developer.mozilla.org/ja/search?q={{SelectedText}:P}" }
                              , { condition: { matchMode: "regex", active: { title: "\.(ahk|ahk2|ah2)" } }, action: "{Run|R}https://www.autohotkey.com/search?q={{SelectedText}:P}" } ]).on()
