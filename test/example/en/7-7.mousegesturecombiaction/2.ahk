#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

items := [ { gestures: [ "MoveUp" ], action: "{ToolTip}MoveUp" }]

new CustomHotkey("RCtrl & Up", { items: items }).on()
new CustomHotkey("RCtrl & Down", items).on()
