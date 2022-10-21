#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

submenu := [ { label: "sub item", action: "{ToolTip}sub item" } ]
new CustomHotkey("RCtrl & 1", [ { label: "top item"
                                , action: submenu } ]).on()
