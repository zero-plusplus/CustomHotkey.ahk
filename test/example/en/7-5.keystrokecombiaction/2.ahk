#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", [ { key: "$", desc: "1", action: "{ToolTip}1" }
                              , { key: "$", desc: "2", action: "{ToolTip}2" }
                              , { key: "$", desc: "3", action: "{ToolTip}3" }
                              , { key: "F$", desc: "F1", action: "{ToolTip}F1" }
                              , { key: "F$", desc: "F2", action: "{ToolTip}F2" }
                              , { key: "F$", desc: "F3", action: "{ToolTip}F3" } ]).on()
