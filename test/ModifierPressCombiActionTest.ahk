#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { trigger: "{ToolTip}trigger"
                              , shift: "{ToolTip}trigger+shift"
                              , alt: "{ToolTip}trigger+alt"
                              , [ "shift", "alt" ]: "{ToolTip}trigger+shift+alt"}).on()
