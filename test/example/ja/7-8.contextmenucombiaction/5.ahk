#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", [ { label: "カスタム項目", action: Func("CustomMenuItem") } ]).on()
CustomMenuItem(itemName, itemPos, menuName) {
  MsgBox,
  (LTrim
    メニュー名: %menuName%
    項目名: %itemName%
    項目番号: %itemPos%
  )
}
