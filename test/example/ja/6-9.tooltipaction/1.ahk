#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { tooltip: "このメッセージは3秒間表示される", displayTime: "3s" }).on()

; ツールチップの常時表示と非表示
new CustomHotkey("RCtrl & 2", { tooltip: "このメッセージは常に表示される", id: 19 }).on()
new CustomHotkey("RCtrl & 3", { tooltip: "", id: 19 }).on()
