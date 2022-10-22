#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

items := []
items.push({ command: "foo", action: "{ToolTip}foo"})
items.push({ command: "foobar", action: "{ToolTip}foobar"})
new CustomHotkey("RCtrl & 1", { matcher: ForwardMatcher, items: items }).on()
new CustomHotkey("RCtrl & 2", { matcher: ForwardMatcher, matcherOptions: { caseSensitive: true }, items: items }).on()

class ForwardMatcher {
  score(a, b, options) {
    if (b == "") {
      return 1
    }
    if (this._startsWith(a, b, options.caseSensitive)) {
      return StrLen(b)
    }
    return 0
  }
  parse(a, b, options) {
    segments := []

    if (b == "") {
      segments.push([ a, false ])
      return segments
    }
    if (this._startsWith(a, b, options.caseSensitive)) {
      segments.push([ SubStr(a, 1, StrLen(b)), true ])
      segments.push([ SubStr(a, StrLen(b) + 1), false ])
      return segments
    }
    return segments
  }
  /**
   * `str`が`prefix`で始まるかどうかを判定します。
   */
  _startsWith(str, prefix, caseSensitive := false) {
    str_prefix := SubStr(str, 1, StrLen(prefix))
    return InStr(str_prefix, prefix, caseSensitive)
  }
}
