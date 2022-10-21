#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

hotkeyInstance := new CustomHotkey("RCtrl & 1", "a")
hotkeyInstance2 := new CustomHotkey("RCtrl & 1", "b", "ahk_exe notepad.exe")

hotkeyInstance.register()
hotkeyInstance2.register()
