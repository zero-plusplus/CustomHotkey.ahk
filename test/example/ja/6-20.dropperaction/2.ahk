#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { dropper: "color" }).on()
new CustomHotkey("RCtrl & 2", { dropper: "color", options: { template: "R: {R}, G: {G}, B: {B}", method: "Slow" } }).on()
