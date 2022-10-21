#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "{ToolTip|T3s}The mouse cursor is on the right side of the screen").on()
new CustomHotkey("RCtrl & 1", "{ToolTip|T3s}The mouse cursor is on the left side of the screen", Func("CustomCondition")).on()
CustomCondition() {
  MouseGetPos, x
  return x < (A_ScreenWidth / 2)
}
