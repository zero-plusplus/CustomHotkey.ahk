#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "{ToolTip}Notepad is activated", new CustomHotkey.WindowCondition("ahk_exe notepad.exe")).on()
new CustomHotkey("RCtrl & 1", "{ToolTip}VSCode is activated", new CustomHotkey.WindowCondition("ahk_exe Code.exe")).on()
