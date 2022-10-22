#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

CustomHotkey.SendAction.defaultOptions.mode := "Input"
CustomHotkey.SendAction.defaultOptions.limitLength := 1

new CustomHotkey("RCtrl & 1", "{a}{b}{c}").on()
