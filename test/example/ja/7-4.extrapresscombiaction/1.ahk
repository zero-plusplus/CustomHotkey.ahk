#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("変換 & 無変換", { q: "^{c}" , w: "^{v}", "e|R10ms": "^{z}" }).on()
