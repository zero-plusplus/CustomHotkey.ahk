#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("変換 & 無変換", { q: { w: { "e|R10ms": "{ToolTip}トリガー & q & w & e" } } }).on()
