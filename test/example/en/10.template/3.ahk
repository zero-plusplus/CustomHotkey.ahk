#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
; CustomHotkey.debugMode := true

new NotepadHotkeys().on()
class NotepadHotkeys extends CustomHotkey.Template {
  condition := "ahk_exe notepad.exe"
  __NEW() {
    this.add("RCtrl & 1", [ 150, "{ToolTip}1" ])
  }
  onExecuting() {
    OutputDebug Execute Action`n
    return A_TickCount
  }
  onExecuted(startTime_ms) {
    elapsedTime_ms := A_TickCount - startTime_ms
    OutputDebug Action took %elapsedTime_ms% ms to execute`n
  }
  onWindowActivate() {
    ToolTip Notepad is activated
    return A_TickCount
  }
  onWindowInactivate(activeWindowInfo, startTime_ms) {
    elapsedTime_ms := A_TickCount - startTime_ms
    ToolTip
    OutputDebug, Window was active for %elapsedTime_ms% ms`n
  }
}
