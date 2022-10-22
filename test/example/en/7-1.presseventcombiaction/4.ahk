#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { single: "{ToolTip}single"
                              , long: "{ToolTip}long"
                              , double: "{ToolTip}double"
                              , triple: "{ToolTip}triple"
                              , quadruple: "{ToolTip}quadruple"
                              , quintuple: "{ToolTip}quintuple"}).on()
