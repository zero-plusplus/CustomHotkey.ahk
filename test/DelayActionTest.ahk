#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", [ "a", 250, "b", 250, "c" ]).on()
new CustomHotkey("RCtrl & 2", [ "a", { delay: "1s" }, "b", { delay: "0.5s" }, "c" ]).on()
