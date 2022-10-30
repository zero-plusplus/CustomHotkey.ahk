#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1|F", "{Exit}Exit script").on()
new CustomHotkey("RCtrl & 2|F", "{Exit|R T3s Owindow}Exit {A_ScriptName}").on()
