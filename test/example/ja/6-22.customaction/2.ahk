#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

; 以下は同じアクションが定義される
new CustomHotkey("RCtrl & 1", "^{a}").on()
new CustomHotkey("RCtrl & 2", new CustomHotkey.SendAction("^{a}")).on()
