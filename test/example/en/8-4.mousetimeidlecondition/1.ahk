#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("c", "^{c}", { mouseTimeIdle: "1s" }).on()
new CustomHotkey("v", "^{v}", { mouseTimeIdle: "1s" }).on()
new CustomHotkey("a", "^{a}", { mouseTimeIdle: "1s" }).on()
