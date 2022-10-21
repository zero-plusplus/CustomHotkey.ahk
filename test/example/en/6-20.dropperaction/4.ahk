#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { dropper: "window" }).on()
new CustomHotkey("RCtrl & 2", { dropper: "window", options: "{ahk_id}" }).on()
