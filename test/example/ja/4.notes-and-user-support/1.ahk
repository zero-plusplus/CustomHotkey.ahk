#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

; 補足: 右Shift(>+), 右Ctrl(>^)
new CustomHotkey(">+>^Esc|F", "{Exit|R}{A_ScriptName}を終了します").on()
; また、AutoHotkeyの再起動ができると便利でしょう
new CustomHotkey(">+>^F5|F", "{Reload|R}{A_ScriptName}を再起動します").on()
