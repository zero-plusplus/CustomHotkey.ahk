#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { single: "{ToolTip}single press"
                              , long: "{ToolTip}long press"
                              , double: "{ToolTip}double press" }).on()
