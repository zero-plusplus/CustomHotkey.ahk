#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { single: "{ToolTip}1度押し"
                              , long: "{ToolTip}長押し"
                              , double: "{ToolTip}2度押し" }).on()
