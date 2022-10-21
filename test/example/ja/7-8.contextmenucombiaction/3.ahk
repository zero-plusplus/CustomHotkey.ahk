#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

submenu := [ { label: "子項目", action: "{ToolTip}子項目" } ]
new CustomHotkey("RCtrl & 1", [ { label: "親項目"
                                , action: submenu } ]).on()
