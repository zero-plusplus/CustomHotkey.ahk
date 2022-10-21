#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("変換 & 1", { trigger: "{ToolTip}トリガー"
                            , shift: "{ToolTip}トリガー+shift"
                            , [ "shift", "ctrl" ]: "{ToolTip}トリガー+shift+ctrl" }).on()
