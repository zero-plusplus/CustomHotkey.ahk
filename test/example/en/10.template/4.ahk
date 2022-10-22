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
  OutputDebug Execute Action`n
  return A_TickCount
}
OnExecuted(startTime_ms) {
  elapsedTime_ms := A_TickCount - startTime_ms
  OutputDebug, Action took %elapsedTime_ms% milliseconds to execute`n
}
OnWindowActivate() {
  ToolTip Notepad is activated
  return A_TickCount
}
OnWindowInactivate(activeWindowInfo, startTime_ms) {
  elapsedTime_ms := A_TickCount - startTime_ms
  ToolTip
  OutputDebug, Window was active for %elapsedTime_ms% ms`n
}
