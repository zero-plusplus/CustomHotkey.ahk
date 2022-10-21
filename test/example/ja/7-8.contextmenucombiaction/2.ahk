#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

items := [ { label: "a", action: "{ToolTip}a" } ]

new CustomHotkey("RCtrl & 1", { items: items }).on()
new CustomHotkey("RCtrl & 2", items).on()
