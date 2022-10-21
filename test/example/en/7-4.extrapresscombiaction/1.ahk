#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("PgUp & PgDn", { q: "^{c}" , w: "^{v}", "e|R10ms": "^{z}" }).on()
