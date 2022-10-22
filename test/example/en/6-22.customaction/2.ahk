#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

; The following defines the same action
new CustomHotkey("RCtrl & 1", "^{a}").on()
new CustomHotkey("RCtrl & 2", new CustomHotkey.SendAction("^{a}")).on()
