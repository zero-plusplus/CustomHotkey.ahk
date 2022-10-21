#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { autoKeys: [ "a", "b", "c"]
                              , autoFunctionKeys: [ "F1", "F5", "F9" ]
                              , items: [ { key: "$", action: "{ToolTip}a" }
                                       , { key: "$", action: "{ToolTip}b" }
                                       , { key: "$", action: "{ToolTip}c" }
                                       , { key: "F$", action: "{ToolTip}F1" }
                                       , { key: "F$", action: "{ToolTip}F5" }
                                       , { key: "F$", action: "{ToolTip}F9" } ] }).on()
