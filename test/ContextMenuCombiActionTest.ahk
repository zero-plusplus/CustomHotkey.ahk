#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

items := []
items.push({ condition: "{Active|Mbackward}AutoHotkey - Google Chrome"
           , label: "AutoHotkey official site"
           , action: "{ToolTip}AutoHotkey official site" })
items.push({ condition: "{Active|Mbackward}YouTube - Google Chrome"
           , label: "Youtube"
           , action: "{ToolTip}Youtube" })
new CustomHotkey("RCtrl & 1", items).on()

new CustomHotkey("RCtrl & 2", [ { label: "a", align: "right", action: [ { label: "b", action: "{ToolTip|T1s}b" } ] }
                              , "---Comment---"
                              , { label: "c", action: "{ToolTip|T1s}c" }
                              , { label: "d", action: Func("CustomMenuItem") } ]).on()
CustomMenuItem(itemName, itemPos, menuName) {
  MsgBox, Clicked on "%itemName%", the %itemPos% item in "%menuName%"
}