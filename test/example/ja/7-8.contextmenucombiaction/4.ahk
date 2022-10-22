#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", [ { label: "a", action: [ { label: "b", action: "{ToolTip}b" } ] }
                              , "---コメント---"
                              , { label: "c", action: "{ToolTip}c" }
                              , "===コメント==="
                              , { label: "d", action: "{ToolTip}d" } ]).on()
