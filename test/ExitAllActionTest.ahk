#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "{ExitAll}Exit all").on()
new CustomHotkey("RCtrl & 2", "{ExitAll|R Owindow T3s}Exit all").on()
new CustomHotkey("RCtrl & 3", "{ExitAll|E}Exit all without self").on()
