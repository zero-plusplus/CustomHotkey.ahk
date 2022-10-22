#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

items := [ { key: "a", description: "ツールチップにAを表示", action: "{ToolTip}A" } ]

new CustomHotkey("RCtrl & 1", items).on()
new CustomHotkey("RCtrl & 2", { items: items }).on()
