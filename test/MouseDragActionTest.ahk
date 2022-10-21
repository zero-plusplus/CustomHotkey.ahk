#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { to: { x: 100, y: 100 } }).on()
new CustomHotkey("RCtrl & 2", { to: { x: 100, y: 100 }, restore: true }).on()
new CustomHotkey("RCtrl & 3", { to: { x: 100, y: 100 }, restore: -10 }).on()
new CustomHotkey("RCtrl & 4", { to: { origin: "screen-center" } }).on()
