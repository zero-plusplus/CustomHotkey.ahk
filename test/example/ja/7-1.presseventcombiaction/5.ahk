#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("Up & Down", "").on()
new CustomHotkey("Up", { single: "{ToolTip}単押し"
                       , long: "{ToolTip}長押し" ; このアクションは実行されない
                       , double: "{ToolTip}2度押し" }).on()
