#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", [ { label: "custom", action: Func("CustomMenuItem") } ]).on()
CustomMenuItem(itemName, itemPos, menuName) {
  MsgBox, Clicked on "%itemName%", the %itemPos% item in "%menuName%"
}
