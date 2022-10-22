#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { input: ">", items: Func("Commands") }).on()
new CustomHotkey("RCtrl & 2", { input: "@", items: Func("Commands") }).on()
new CustomHotkey("RCtrl & 3", { input: "?", items: Func("Commands") }).on()
Commands() {
  return [ { command: ">group-a", action: "{ToolTip}a" }
         , { command: "@group-b", action: "{ToolTip}b" }
         , { command: "?group-c", action: "{ToolTip}c" } ]
}
