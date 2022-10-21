#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "{ToolTip}default").on()
new CustomHotkey("RCtrl & 1", "{ToolTip}notepad", "ahk_exe notepad.exe").on()
new CustomHotkey("RCtrl & 1", "{ToolTip}chrome", "ahk_exe chrome.exe").on()
