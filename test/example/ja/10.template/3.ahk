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
    OutputDebug アクションを実行します`n
    return A_TickCount
  }
  onExecuted(startTime_ms) {
    elapsedTime_ms := A_TickCount - startTime_ms
    OutputDebug アクションは%elapsedTime_ms%ミリ秒で終了しました`n
  }
  onWindowActivate() {
    ToolTip メモ帳がアクティブです
    return A_TickCount
  }
  onWindowInactivate(activeWindowInfo, startTime_ms) {
    elapsedTime_ms := A_TickCount - startTime_ms
    ToolTip
    OutputDebug, ウィンドウは%elapsedTime_ms%ミリ秒の間アクティブでした`n
  }
}
