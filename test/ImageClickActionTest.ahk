#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { image: { path: A_LineFile . "\..\image\(f).png", variation: 80 }, speed: 0, restore: true }).on()
new CustomHotkey("RCtrl & 2", [ { button: "LButton Down", image: { path: A_LineFile "\..\image\(f).png", variation: 80 }, speed: 0 }
                              , { x: 100 }
                              , { button: "LButton Up"} ] ).on()
