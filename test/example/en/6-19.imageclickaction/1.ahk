#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", [ { button: "LButton Down", image: { path: "path/to/image" }, speed: 0 }
                              , { x: 100 }
                              , { button: "LButton Up"} ] ).on()
