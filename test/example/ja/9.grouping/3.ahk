#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

hotkeys := new CustomHotkey.Group()
hotkeys.add("RCtrl & 1", "^{v}")
hotkeys.add("RCtrl & 2", "^{v}")
hotkeys.on()
