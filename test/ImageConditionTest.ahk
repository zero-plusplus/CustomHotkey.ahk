#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "{ToolTip|T1s}Image found", { image: "*80 " . A_LineFile . "\..\image\(f).png", targetRect: "window" }).on()
new CustomHotkey("RCtrl & 1", "{ToolTip|T1s}Image not found").on()