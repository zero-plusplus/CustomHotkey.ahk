#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { dropper: Func("CustomTarget"), options: { template: "{}, {}" } }).on()
CustomTarget(position, options) {
  return Format(options.template, position.x, position.y)
}
