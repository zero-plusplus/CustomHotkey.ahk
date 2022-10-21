#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new NotepadHotkeys().on()
class NotepadHotkeys extends CustomHotkey.Template {
  condition(winInfo) {
    return winInfo.exe == "notepad.exe"
  }
  __NEW() {
    this.add("RCtrl & 1", "{ToolTip}Notepad is activated")
  }
}
