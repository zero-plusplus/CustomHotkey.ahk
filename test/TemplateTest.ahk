#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

google := new CustomHotkey.Template({ active: { exe: "Chrome.exe" } })
google
  .add("RCtrl & 1", "{ToolTip}a")
  .on()

new EditorHotkeys(NotepadActions).on()
new EditorHotkeys(VsCodeActions).on()
class EditorHotkeys extends CustomHotkey.Template {
  __NEW(actions) {
    this.condition := actions.condition
    this.add("RCtrl & 1", actions.a)
    this.add("RCtrl & 2", actions.b)
    this.onWindowActivate := actions.onWindowActivate
    this.onWindowInactivate := actions.onWindowInactivate
  }
  onExecuting() {
    OutputDebug, % this.__CLASS "`n"
  }
  onExecuted() {
    OutputDebug, % this.__CLASS "`n"
  }
}
class NotepadActions {
  static condition := "ahk_exe notepad.exe"
  static a := "a"
  b() {
    SendInput b
  }
  onWindowActivate() {
    ToolTip メモ帳起動中
  }
  onWindowInactivate() {
    ToolTip
  }
}
class VsCodeActions {
  condition(info) {
    return info.exe == "Code.exe"
  }
  static a := "A"
  b() {
    SendInput B
  }
  onWindowActivate() {
    ToolTip VSCode起動中
  }
  onWindowInactivate() {
    ToolTip
  }
}
