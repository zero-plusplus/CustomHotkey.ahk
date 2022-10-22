#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", [ "a", 250, "b", 250, "c" ]).on()
new CustomHotkey("RCtrl & 2", [ { button: "LButton down" }
                              , { x: 200, y: 200 }
                              , { button: "LButton up" } ]).on()

new CustomHotkey("RCtrl & 3", [ Func("GetSelectedText"), Func("SearchByGoogle") ]).on()
new CustomHotkey("RCtrl & 4", [ Func("GetSelectedText"), Func("TranslateByGoogle") ]).on()
GetSelectedText(data, done) {
  selectedText := CustomHotkey.Util.getSelectedText()
  if (selectedText == "") {
    return done
  }
  return selectedText
}
SearchByGoogle(data, done) {
  if (data == "") {
    return done
  }
  query := CustomHotkey.Util.escapeUriComponent(data)
  Run, https://www.google.com/search?q=%query%
}
TranslateByGoogle(data, done) {
  if (data == "") {
    return done
  }
  query := CustomHotkey.Util.escapeUriComponent(data)
  Run, https://translate.google.co.jp/?sl=auto&tl=ja&text=%query%
}