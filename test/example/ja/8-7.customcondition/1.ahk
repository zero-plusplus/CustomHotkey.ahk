#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "{ToolTip|T3s}マウスカーソルは画面の右側にあります").on()
new CustomHotkey("RCtrl & 1", "{ToolTip|T3s}マウスカーソルは画面の左側にあります", Func("CustomCondition")).on()
CustomCondition() {
  MouseGetPos, x
  return x < (A_ScreenWidth / 2)
}
