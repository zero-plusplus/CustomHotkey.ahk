#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", Func("ExampleAction")).on()
new CustomHotkey("RCtrl & 2", Func("ExampleAction")).on()
new CustomHotkey("RCtrl & 3", Func("ExampleAction_B")).on()
ExampleAction() {
  trigger := new CustomHotkey.Trigger(A_ThisHotkey)

  key := trigger.key
  SendInput, +{%key%}
  trigger.waitRelease()
}
ExampleAction_B() {
  trigger := new CustomHotkey.Trigger(A_ThisHotkey)
  ToolTip pressing
  while (trigger.pressingAll) {
    Sleep, 50
  }
  ToolTip
}
