#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

CustomHotkey.MouseClickAction.defaultOptions.speed := 0

new CustomHotkey("RCtrl & 1", { button: "LButton" }).on()
new CustomHotkey("RCtrl & 2", { button: "Left down" }).on()
new CustomHotkey("RCtrl & 3", { button: "Left up" }).on()
new CustomHotkey("RCtrl & 4", { button: "LButton", x: 100, restore: true }).on()
new CustomHotkey("RCtrl & 5", { button: "LButton", x: 100, restore: -100 }).on()
new CustomHotkey("RCtrl & 6", { button: "LButton", count: 2, origin: "caret-middle-left" }).on()
new CustomHotkey("RCtrl & 7", { button: "LButton", origin: "screen-center" }).on()
new CustomHotkey("RCtrl & 8", { button: "LButton", origin: "screens-center" }).on()
