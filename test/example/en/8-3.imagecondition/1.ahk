#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

condition := { image: A_ScriptDir . "\..\..\..\image\(f).png", targetRect: "window" }
new CustomHotkey("RCtrl & 1", "{ToolTip}Image found", condition).on()
new CustomHotkey("RCtrl & 1", "{ToolTip}Image not found").on()
