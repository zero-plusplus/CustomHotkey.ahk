#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

; クラスベースのアクション定義
class NotepadActions {
  static condition := "ahk_exe notepad.exe"
  static clearLine := "{End}+{Home}{Delete}"
  onWindowActivate() {
    ToolTip メモ帳がアクティブです
  }
  onWindowInactivate() {
    ToolTip
  }
}
; オブジェクトベースのアクション定義
VsCodeActions := { condition: "ahk_exe Code.exe"
                 , clearLine: "^+k"
                 , onWindowActivate: Func("OnWindowActivate")
                 , onWindowInactivate: Func("OnWindowInactivate") }
OnWindowActivate() {
  ToolTip VSCodeがアクティブです
}
OnWindowInactivate() {
  ToolTip
}

; ホットキーの登録
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
