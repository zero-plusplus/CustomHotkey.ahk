#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

conditions := [ "ahk_exe chrome.exe"
              , "{Active|Mbackward}YouTube - Google Chrome" ]
new CustomHotkey("RCtrl & 1", "{ToolTip}YouTube", { and: conditions }).on()
