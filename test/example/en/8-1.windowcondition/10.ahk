#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "{ToolTip}Notepad is activated", "{Exist}ahk_exe notepad.exe").on()
