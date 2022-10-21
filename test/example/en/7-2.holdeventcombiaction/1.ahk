#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { hold: { button: "LButton down" }
                              , release: { button: "LButton up" } }).on()
new CustomHotkey("RCtrl & 2", { tap: "{ToolTip}tap"
                              , "hold|R50ms": "{ToolTip}hold"
                              , release: "{ToolTip}release" }).on()
