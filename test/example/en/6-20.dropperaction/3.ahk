#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { dropper: "coordinates" }).on()
new CustomHotkey("RCtrl & 2", { dropper: "coordinates", options: "x: {x}`ny: {y}" }).on()
new CustomHotkey("RCtrl & 3", { dropper: "coordinates", options: { origin: "window" } }).on()
