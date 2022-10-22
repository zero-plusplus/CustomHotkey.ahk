#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { single: "{ToolTip}単押し"
                              , long: "{ToolTip}長押し"
                              , double: "{ToolTip}2度押し"
                              , triple: "{ToolTip}3度押し"
                              , quadruple: "{ToolTip}4度押し"
                              , quintuple: "{ToolTip}5度押し"}).on()
