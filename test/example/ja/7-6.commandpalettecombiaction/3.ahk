#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { tip: { limitDescriptionLength: 0 }, items: Func("Explorer").bind("C:") }).on()
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
