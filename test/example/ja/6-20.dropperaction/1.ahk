#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", [ { key: "q", desc: "color", action: { dropper: "color" } }
                              , { key: "w", desc: "coordinates", action: { dropper: "coordinates" } }
                              , { key: "e", desc: "window", action: { dropper: "window" } } ]).on()
