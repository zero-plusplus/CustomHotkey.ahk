#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

Gui, +LastFound
Gui Add, Edit, , Example
Gui Show
guiHwnd := (WinExist() + 0) ; Convert to pure number

new CustomHotkey("RCtrl & 1", "a", { exist: guiHwnd }).on()
; The following has the same meaning as above
new CustomHotkey("RCtrl & 2", "a", { exist: "ahk_id " guiHwnd }).on()
