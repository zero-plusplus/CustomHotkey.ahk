#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

defaultHotkeys := new CustomHotkey.Group()
defaultHotkeys.add(new CustomHotkey("RCtrl & 1", "a"))
defaultHotkeys.add("RCtrl & 2", "c")

notepadHotkeys := new CustomHotkey.Group()
notepadHotkeys.add(new CustomHotkey("RCtrl & 1", "b", "ahk_exe notepad.exe"))
notepadHotkeys.add("RCtrl & 2", "d", "ahk_exe notepad.exe")

hotkeys := new CustomHotkey.Group()
hotkeys.add(defaultHotkeys)
hotkeys.add(notepadHotkeys)
hotkeys.on()
