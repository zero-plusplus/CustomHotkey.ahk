#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

conditions := [ "ahk_exe chrome.exe"
              , "ahk_exe msedge.exe"
              , "ahk_exe firefox.exe" ]
new CustomHotkey("RCtrl & 1", "{ToolTip}Browser", { or: conditions }).on()
