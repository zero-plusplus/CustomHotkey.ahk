#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

; Send keys with delay
new CustomHotkey("RCtrl & 1", [ "a", 250, "b", 250, "c" ]).on()

; Reproduce MouseDragAction by combining Actions
new CustomHotkey("RCtrl & 2", [ { button: "LButton down" }
                              , { x: 200, y: 200 }
                              , { button: "LButton up" } ]).on()
