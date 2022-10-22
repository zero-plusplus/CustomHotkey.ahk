#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "{ToolTip}メモ帳がアクティブです", Func("CustomCondition")).on()
CustomCondition(winInfo) {
  return winInfo.exe == "notepad.exe"
}
