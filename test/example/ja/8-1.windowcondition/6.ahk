#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

Gui, +LastFound
Gui Add, Edit, , Example
Gui Show
guiHwnd := (WinExist() + 0) ; 純粋な数値に変換

new CustomHotkey("RCtrl & 1", "a", guiHwnd).on()
; 以下は上記と同じ意味を持ちます
new CustomHotkey("RCtrl & 2", "a", "ahk_id " guiHwnd).on()
