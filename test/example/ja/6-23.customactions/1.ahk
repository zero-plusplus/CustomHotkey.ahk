#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

; 遅延しながらキーを送信する
new CustomHotkey("RCtrl & 1", [ "a", 250, "b", 250, "c" ]).on()

; アクションを組み合わせてMouseDragActionを再現する
new CustomHotkey("RCtrl & 2", [ { button: "LButton down" }
                              , { x: 200, y: 200 }
                              , { button: "LButton up" } ]).on()
