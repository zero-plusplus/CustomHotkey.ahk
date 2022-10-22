#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { ime: false }).on()
new CustomHotkey("RCtrl & 2", { ime: true }).on()
