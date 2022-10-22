#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", [ { label: "a", action: [ { label: "b", action: "{ToolTip}b" } ] }
                              , "---Comment---"
                              , { label: "c", action: "{ToolTip}c" }
                              , "===Comment==="
                              , { label: "d", action: "{ToolTip}d" } ]).on()
