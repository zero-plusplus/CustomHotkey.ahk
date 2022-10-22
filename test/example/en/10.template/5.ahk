#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

; Class-based Actions definition
class NotepadActions {
  static condition := "ahk_exe notepad.exe"
  static clearLine := "{End}+{Home}{Delete}"
  onWindowActivate() {
    ToolTip Notepad is activated
  }
  onWindowInactivate() {
    ToolTip
  }
}
; Object-based Actions definition
VsCodeActions := { condition: "ahk_exe Code.exe"
                 , clearLine: "^+k"
                 , onWindowActivate: Func("OnWindowActivate")
                 , onWindowInactivate: Func("OnWindowInactivate") }
OnWindowActivate() {
  ToolTip VSCode is activated
}
OnWindowInactivate() {
  ToolTip
}

; Register hotkeys
new EditorHotkeys(NotepadActions).on()
new EditorHotkeys(VsCodeActions).on()
class EditorHotkeys extends CustomHotkey.Template {
  __NEW(actions) {
    this.condition := actions.condition

    this.add("RCtrl & 1", actions.clearLine)

    this.onWindowActivate := actions.onWindowActivate
    this.onWindowInactivate := actions.onWindowInactivate
  }
}
