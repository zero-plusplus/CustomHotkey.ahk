#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("Up & Down", "").on()
new CustomHotkey("Up", { single: "{ToolTip}single"
                       , long: "{ToolTip}long" ; This Action cannot be executed
                       , double: "{ToolTip}double" }).on()
