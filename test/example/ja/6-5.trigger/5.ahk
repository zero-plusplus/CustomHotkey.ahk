#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

; xに実際のコードを設定します
CustomHotkey.CustomLabel.add("カスタムラベル1", "vkxx")
CustomHotkey.CustomLabel.add({ "カスタムラベル1": "vkxx", "カスタムラベル2": "scxxx" })
