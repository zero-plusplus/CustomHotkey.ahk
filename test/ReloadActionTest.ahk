#SingleInstance Force
#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1|F", "{Reload}Reload script").on()
new CustomHotkey("RCtrl & 2|F", "{Reload|Owindow R T3s}Reload {A_ScriptName}").on()
