#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("z & 1", { trigger: "{ToolTip}trigger"
                          , shift: "{ToolTip}trigger+shift"
                          , [ "shift", "ctrl" ]: "{ToolTip}trigger+shift+ctrl" }).on()
