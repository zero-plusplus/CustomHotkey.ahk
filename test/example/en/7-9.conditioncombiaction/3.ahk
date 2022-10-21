#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

items := [ { condition: "ahk_exe notepad.exe", action: "{ToolTip}notepad" } ]

new CustomHotkey("RCtrl & 1", { items: items }).on()
new CustomHotkey("RCtrl & 2", items).on()
