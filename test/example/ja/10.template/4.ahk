#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
; CustomHotkey.debugMode := true

notepad := new CustomHotkey.Template("ahk_exe notepad.exe")
notepad.add("RCtrl & 1", [ 150, "{ToolTip}1" ])
notepad.onExecuting := Func("onExecuting")
notepad.onExecuted := Func("onExecuted")
notepad.onWindowActivate := Func("OnWindowActivate")
notepad.onWindowInactivate := Func("OnWindowInactivate")
notepad.on()

OnExecuting() {
  OutputDebug アクションを実行します`n
  return A_TickCount
}
OnExecuted(startTime_ms) {
  elapsedTime_ms := A_TickCount - startTime_ms
  OutputDebug, アクションは%elapsedTime_ms%ミリ秒で終了しました`n
}
OnWindowActivate() {
  ToolTip メモ帳がアクティブです
  return A_TickCount
}
OnWindowInactivate(activeWindowInfo, startTime_ms) {
  elapsedTime_ms := A_TickCount - startTime_ms
  ToolTip
  OutputDebug, ウィンドウは%elapsedTime_ms%ミリ秒の間アクティブでした`n
}
