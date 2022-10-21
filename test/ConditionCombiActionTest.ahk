#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { defaultAction: "a", items: [ { condition: "ahk_exe notepad.exe",  action: "b" } ] }).on()
new CustomHotkey("RCtrl & 2", [ { condition: false, action: { run: "https://www.google.com/search", replace: true, args: [ "?q=", "{{SelectedText}}"] } }
                              , { condition: { matchMode: "regex", active: { title: "\.(js|ts)" } }, action: { run: "https://developer.mozilla.org/ja/search", replace: true, args: [ "?q=", "{{SelectedText}}"] } }
                              , { condition: { matchMode: "regex", active: { title: "\.(ahk|ahk2|ah2)" } }, action: { run: "https://www.autohotkey.com/search", replace: true, args: [ "?q=", "{{SelectedText}}"] } } ] ).on()
