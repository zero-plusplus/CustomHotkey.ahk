#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

; Change the URL to open depending on the extension included in the window title
new CustomHotkey("RCtrl & 1", { run: Func("GetDocumentUrl") }).on()
GetDocumentUrl() {
  WinGetTitle, title, A
  if (title ~= "\.ahk") {
    return "https://www.autohotkey.com/docs/AutoHotkey.htm"
  }
  if (title ~= "\.(ahk2|ah2)") {
    return "https://lexikos.github.io/v2/docs/AutoHotkey.htm"
  }
  return "https://www.google.com"
}
