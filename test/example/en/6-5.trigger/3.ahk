#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 3", "{a}")
  .setEnableBuffer(false)
  .setMaxThreads(5)
  .setInputLevel(1)
  .on()
