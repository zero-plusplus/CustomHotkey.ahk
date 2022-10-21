#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "{ToolTip}on", { ime: true }).on()
new CustomHotkey("RCtrl & 1", "{ToolTip}off", { ime: false }).on()
