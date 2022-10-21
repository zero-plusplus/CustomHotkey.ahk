#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "a", { ime: true }).on()
new CustomHotkey("RCtrl & 1", "b", { ime: false }).on()
