#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

hotkeys := new CustomHotkey.Group()
hotkeys.add({ "RCtrl & 1": "a"
            , [ "RCtrl & 2", "RCtrl & 3" ]: "b" })
hotkeys.on()

; The second argument can be a condition
notepadHotkeys := new CustomHotkey.Group()
notepadHotkeys.add({ "RCtrl & 1": "c"
                   , [ "RCtrl & 2", "RCtrl & 3" ]: "d" }, "ahk_exe notepad.exe")
notepadHotkeys.on()
