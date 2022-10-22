#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { tooltip: "This message will be displayed for 3 seconds.", displayTime: "3s" }).on()

; Always show and hide tooltip
new CustomHotkey("RCtrl & 2", { tooltip: "This message is always displayed", displayTime: 0, id: 19 }).on()
new CustomHotkey("RCtrl & 3", { tooltip: "", id: 19 }).on()
