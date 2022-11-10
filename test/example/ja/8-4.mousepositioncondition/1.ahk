#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("LButton", "{LWin}", { mousepos: "screen-primary-right-edge" }).on()
