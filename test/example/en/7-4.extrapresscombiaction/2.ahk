#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("PgUp & PgDn", { q: { w: { "e|R10ms": "{ToolTip}PgUp & PgDn & q & w & e" } } }).on()
