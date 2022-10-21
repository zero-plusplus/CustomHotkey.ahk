#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { run: "notepad", args: [ A_LineFile ] }).on()
new CustomHotkey("RCtrl & 2", { run: "https://www.google.com/search", replace: true, args: [ "?q=", "{{SelectedText}}" ] }).on()
