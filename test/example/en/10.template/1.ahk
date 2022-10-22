#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new DefaultHotkeys().on()
class DefaultHotkeys extends CustomHotkey.Template {
  __NEW() {
    this.add("RCtrl & 1", "{ToolTip}1")
    this.add({ "RCtrl & 2": "{ToolTip}2", "RCtrl & 3": "{ToolTip}3" })
    this.add([ "RCtrl & 4", "RCtrl & 5" ], this.fullscreen)
  }
  fullscreen() {
    WinMove, A, , 0, 0, %A_ScreenWidth%, %A_ScreenHeight%
  }
}

new NotepadHotkeys().on()
class NotepadHotkeys extends CustomHotkey.Template {
  static condition := "ahk_exe notepad.exe"
  __NEW() {
    this.add("RCtrl & 1", "{ToolTip}Notepad is activated")
  }
}
