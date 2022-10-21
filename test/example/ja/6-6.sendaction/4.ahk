#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "{Input|I1}on").on()
new CustomHotkey("RCtrl & 2", "{Input|I0}off").on()
