#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "{Run|R Mmax}notepad {'" . A_LineFile . "':Q}").on()
new CustomHotkey("RCtrl & 2", "{Run|R}https://www.google.com/search?q={{SelectedText}}").on()
