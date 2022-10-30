; https://github.com/zero-plusplus/CustomHotkey.ahk/issues/17

#Include %A_LineFile%\..\..\src\CustomHotkey.ahk

new CustomHotkey("RCtrl & 1", new CustomHotkey.TrayTipAction("message")).on()
