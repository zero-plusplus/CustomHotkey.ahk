#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "{Input|I1s}{a}").on()
new CustomHotkey("RCtrl & 2", "{Input|I-1s}{a}").on()
