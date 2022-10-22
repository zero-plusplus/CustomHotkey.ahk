#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "{Exit}Exit script").on()
new CustomHotkey("RCtrl & 2", "{Exit|R T3s Owindow}Exit {A_ScriptName}").on()
