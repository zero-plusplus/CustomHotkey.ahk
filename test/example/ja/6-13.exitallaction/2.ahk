#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { exitAll: "すべてのスクリプトを終了します", tip: { displayTime: "0.5s" } }).on()
