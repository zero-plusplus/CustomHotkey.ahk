#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { reload: "スクリプトを再起動します", tip: { displayTime: "0.5s" } }).on()
