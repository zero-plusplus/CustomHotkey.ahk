#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

items := []
items.push({ label: "この項目は常に表示される"
           , action: "{ToolTip}この項目は常に表示される" })
items.push({ condition: "{Active|Mbackward}AutoHotkey - Google Chrome"
           , label: "AutoHotkey公式ドキュメント"
           , action: "{ToolTip}AutoHotkey公式ドキュメント" })
items.push({ condition: "{Active|Mbackward}YouTube - Google Chrome"
           , label: "Youtube"
           , action: "{ToolTip}Youtube" })
new CustomHotkey("RCtrl & 1", items).on()
