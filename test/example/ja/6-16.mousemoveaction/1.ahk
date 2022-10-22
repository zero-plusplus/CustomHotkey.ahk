#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

; 画面の中心にマウスを移動
new CustomHotkey("RCtrl & 1", { origin: "screen-center" }).on()

; 現在位置から右に50ピクセル移動する
new CustomHotkey("RCtrl & 2", { x: 50 }).on()
