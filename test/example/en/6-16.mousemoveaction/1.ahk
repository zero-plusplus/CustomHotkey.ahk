#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

; Move mouse to center of screen
new CustomHotkey("RCtrl & 1", { origin: "screen-center" }).on()

; Move 50 pixels to the right from the current position
new CustomHotkey("RCtrl & 2", { x: 50 }).on()
