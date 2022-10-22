#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { run: "notepad", args: [ A_LineFile ] }).on()
new CustomHotkey("RCtrl & 2", "{Run|R}notepad {'" . A_LineFile . "':Q}").on()

new CustomHotkey("RCtrl & 3", { run: "https://www.google.com/search", replace: true, args: [ "?q=", "{{SelectedText}}" ] }).on()
new CustomHotkey("RCtrl & 4", "{Run|R}https://www.google.com/search?q={{SelectedText}}").on()

new CustomHotkey("RCtrl & q", { run: "notepad" }).on()
new CustomHotkey("RCtrl & w", { run: "notepad", args: [ A_LineFile ] }).on()
new CustomHotkey("RCtrl & e", { run: "notepad", rawArgsMode: true, args: [ A_LineFile ] }).on()

new CustomHotkey("RCtrl & r", "{Run}notepad " A_LineFile).on()
new CustomHotkey("RCtrl & t", { run: A_LineFile, verb: "properties" }).on()
new CustomHotkey("RCtrl & y", [ { run: "notepad", wait: true }
                              , { tooltip: "Closed notepad", displayTime_s: 1 } ]).on()

new CustomHotkey("RCtrl & a", { run: "https://www.google.com/" }).on()
new CustomHotkey("RCtrl & s", { run: "https://www.google.com/search", replace: true, args: [ "?q=", "{{SelectedText}}" ] }).on()
new CustomHotkey("RCtrl & d", "{Run|R}https://translate.google.co.jp/?text={'@a&b|/test':P}&sl=auto&tl=en&op=translate").on()
new CustomHotkey("RCtrl & f", "{Run|R}https://www.deepl.com/translator#auto/en/{'@a&b|/test':PB}").on()

new CustomHotkey("RCtrl & z", { run: Func("GetDocumentUrl") }).on()
GetDocumentUrl() {
  WinGetTitle, title, A
  if (title ~= "\.(ahk2|ah2)") {
    return "https://lexikos.github.io/v2/docs/AutoHotkey.htm"
  }
  if (title ~= "\.ahk") {
    return "https://www.autohotkey.com/docs/AutoHotkey.htm"
  }
  return "https://www.google.com"
}
new CustomHotkey("RCtrl & x", { run: "https://www.google.com/search", args: [ "?q=", Func("getClipboard") ] }).on()
getClipboard() {
  return Clipboard
}
