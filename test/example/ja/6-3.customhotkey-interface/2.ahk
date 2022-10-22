#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

hotkeyInstance := new CustomHotkey("RCtrl & 1", "^{a}").on()
