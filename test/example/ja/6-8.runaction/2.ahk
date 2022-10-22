#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

; ウィンドウタイトルに含まれる拡張子によって開くURLを変更する
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
