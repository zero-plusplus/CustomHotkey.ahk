#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { items: [ { label: "a", action: "{ToolTip|T1s}a" }
                                       , { label: "b", action: "{ToolTip|T1s}b" } ] }).on()
