#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

; RShift(>+), RCtrl(>^)
new CustomHotkey(">+>^Esc|F", "{Exit|R}Exit {A_ScriptName}").on()
; It would be useful to be able to restart the script
new CustomHotkey(">+>^F5|F", "{Reload|R}Reload {A_ScriptName}").on()
