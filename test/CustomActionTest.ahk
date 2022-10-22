#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", Func("MoveActiveWindow").bind(0, 0, A_ScreenWidth, A_ScreenHeight)).on()
MoveActiveWindow(x := "", y := "", width := "", height := "") {
  WinMove, A, , %x%, %y%, %width%, %height%
}