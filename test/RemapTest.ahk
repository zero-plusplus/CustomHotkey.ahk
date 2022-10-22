#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey.Remap("Shift", "Ctrl").on()
new CustomHotkey.Remap("Ctrl", "Shift").on()
new CustomHotkey.Remap("a", "b", { active: { exe: "notepad.exe" } }).on()
