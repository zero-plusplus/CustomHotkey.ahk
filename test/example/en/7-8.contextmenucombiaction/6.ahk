#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

items := []
items.push({ label: "This item is always displayed"
           , action: "{ToolTip}This item is always displayed" })
items.push({ condition: "{Active|Mbackward}AutoHotkey - Google Chrome"
           , label: "AutoHotkey Official Document"
           , action: "{ToolTip}AutoHotkey Official Document" })
items.push({ condition: "{Active|Mbackward}YouTube - Google Chrome"
           , label: "Youtube"
           , action: "{ToolTip}Youtube" })
new CustomHotkey("RCtrl & 1", items).on()
