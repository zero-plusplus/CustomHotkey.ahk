#Include %A_LineFile%\..\..\src\CustomHotkey.ahk

CustomHotkey.debugMode := true
CustomHotkey.CommandPaletteCombiAction.defaultOptions.tip.origin := "mouse"
CustomHotkey.CommandPaletteCombiAction.defaultOptions.fontType := "sans-serif-italic"
SetBatchLines, -1

new CustomHotkey("RCtrl & 1", { items: [ { command: "copy"
                                         , description: "選択テキストをコピー"
                                         , action: "^c" }
                                       , { command: "cut"
                                         , description: "選択テキストをカット"
                                         , action: "^x" }
                                       , { command: "paste"
                                         , description: "ペースト"
                                         , action: "^v" } ] }).on()
new CustomHotkey("RCtrl & 2", [ { command: "abc"
                                , description: "abc"
                                , action: "{ToolTip}abc" }
                              , { command: "abcd"
                                , description: "abcd"
                                , action: "{ToolTip}abcd" }
                              , { command: "123"
                                , description: "1`n2`n3"
                                , action: "\{ToolTip\}}1`n2`n3" } ]).on()
new CustomHotkey("RCtrl & 3", [ { command: "menu", description: "ContextMenuCombiAction", action: [ { label: "a", action: "a" } ] }
                              , { command: "commandpalette", description: "CommandPaletteCombiAction", action: [ { command: "a", action: "a" } ] } ]).on()
items := []
items.push({ command: "foobar", description: "ContextMenuCombiAction", action: "{ToolTip}foobar" })
items.push({ command: "FooBar", description: "ContextMenuCombiAction", action: "{ToolTip}FooBar" })
items.push({ command: "FoobarBar", description: "ContextMenuCombiAction", action: "{ToolTip}FoobarBar" })
items.push({ command: "FboobarBar", description: "ContextMenuCombiAction", action: "{ToolTip}FboobarBar" })
items.push({ command: "Foo-Bar", description: "CommandPaletteCombiAction", action: "{ToolTip}Foo-Bar" })
items.push({ command: "Foo_Bar", description: "CommandPaletteCombiAction", action: "{ToolTip}Foo_Bar" })
items.push({ command: "Foo/Bar", description: "CommandPaletteCombiAction", action: "{ToolTip}Foo/Bar" })
items.push({ command: "Foo\Bar", description: "CommandPaletteCombiAction", action: "{ToolTip}Foo\Bar" })
items.push({ command: "Foo\Bar", description: "CommandPaletteCombiAction", action: "{ToolTip}Foo\Bar" })
items.push({ command: "Foo.Bar", description: "CommandPaletteCombiAction", action: "{ToolTip}Foo.Bar" })
items.push({ command: "FooBarAor", description: "ContextMenuCombiAction", action: "{ToolTip}foobar" })
items.push({ command: "FooAorBar", description: "ContextMenuCombiAction", action: "{ToolTip}FooBar" })
new CustomHotkey("RCtrl & 4", items).on()
new CustomHotkey("RCtrl & 5", { items: Func("CreateList") }).on()
CreateList() {
  list := []
  Loop 1000 {
    list.push({ command: A_Index, description: A_Index, action: { trigger: A_Index . "", ctrl: "[" A_Index "]" } })
  }
  return list
}

new CustomHotkey("RCtrl & 6", { tip: { limitDescriptionLength: 0 }, items: Func("Explorer").bind("C:") }).on()
Explorer(root) {
  list := []
  Loop Files, %root%\*, FD
  {
    try {
      FileGetAttrib, attribute, %A_LoopFileLongPath%
      if (InStr(attribute, "H") || InStr(attribute, "S")) {
        continue
      }
      if (InStr(attribute, "D")) {
        list.push({ command: A_LoopFileName
                  , icon: "📂"
                  , desc: A_LoopFileLongPath
                  , action: { trigger: { tip: { limitDescriptionLength: 0 }
                                       , items: Func("Explorer").bind(A_LoopFileLongPath) }
                            , ctrl: "{ToolTip}" . A_LoopFileLongPath } })
      }
      else {
        list.push({ command: A_LoopFileName
                  , icon: "📄"
                  , desc: A_LoopFileLongPath
                  , action: "{ToolTip}" . A_LoopFileLongPath })
      }
    }
  }
  return list
}

new CustomHotkey("RCtrl & 7", { tip: { limitDescriptionLength: 0 }, items: Func("List") }).on()
List() {
  list := []
  Loop 1000 {
    list.push({ command: A_Index, desc: A_Index, action: "{ToolTip}" A_Index })
  }
  return list
}
new CustomHotkey("RCtrl & q", { input: ">", items: Func("Commands") }).on()
new CustomHotkey("RCtrl & w", { input: "@", items: Func("Commands") }).on()
new CustomHotkey("RCtrl & e", { input: "?", items: Func("Commands") }).on()
Commands() {
  return [ { command: ">group-a", action: "a" }
         , { command: "@group-b", action: "b" }
         , { command: "?group-c", action: "c" }
         , { command: "^group-c", action: "c" } ]
}
new CustomHotkey("RShift & Up", "{Event}{Up}").on()
new CustomHotkey("RShift & Down", "{Event}{Down}").on()

items := []
items.push({ command: "foo", action: "{ToolTip}foo"})
items.push({ command: "foobar", action: "{ToolTip}foobar"})
new CustomHotkey("RCtrl & z", { matcher: ForwardMatcher, items: items }).on()
new CustomHotkey("RCtrl & x", { matcher: ForwardMatcher, matcherOptions: { caseSensitive: true }, items: items }).on()

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
  _startsWith(str, prefix, caseSensitive := false) {
    str_prefix := SubStr(str, 1, StrLen(prefix))
    return InStr(str_prefix, prefix, caseSensitive)
  }
}