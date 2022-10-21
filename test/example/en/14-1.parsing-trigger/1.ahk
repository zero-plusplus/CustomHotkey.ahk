#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", Func("SendKeyWithShift")).on()
new CustomHotkey("RCtrl & 2", Func("SendKeyWithShift")).on()
new CustomHotkey("RCtrl & 3", Func("DisplayTooltipWhilePressedTrigger")).on()
SendKeyWithShift() {
  trigger := new CustomHotkey.Trigger(A_ThisHotkey)

  key := trigger.key
  SendInput, +{%key%}
  trigger.waitRelease()
}
DisplayTooltipWhilePressedTrigger() {
  trigger := new CustomHotkey.Trigger(A_ThisHotkey)
  ToolTip, Pressing trigger
  while (trigger.pressingAll) {
    Sleep, 50
  }
  ToolTip
}
