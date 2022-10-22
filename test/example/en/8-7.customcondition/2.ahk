#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "{ToolTip}Notepad is activated", Func("CustomCondition")).on()
CustomCondition(winInfo) {
  return winInfo.exe == "notepad.exe"
}
