#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1|F", "{ExitAll}Exit all").on()
new CustomHotkey("RCtrl & 2|F", "{ExitAll|R Owindow T3s}Exit all").on()
new CustomHotkey("RCtrl & 3|F", "{ExitAll|E}Exit all without self").on()
