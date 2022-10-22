#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey.Remap("LCtrl", "Shift").on()
new CustomHotkey.Remap("LShift", "Ctrl").on()
new CustomHotkey.Remap("RShift", "MButton").on()
new CustomHotkey.Remap("RCtrl", "a", "ahk_exe notepad.exe").on()
