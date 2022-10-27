; https://github.com/zero-plusplus/CustomHotkey.ahk/issues/3

#Include %A_LineFile%\..\..\src\CustomHotkey.ahk

action2 := [ { key: "3", action: "{ToolTip}action" } ]
action1 := [ { key: "2", action: action2 } ]
new CustomHotkey("RCtrl & 1", action1).on()