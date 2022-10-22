#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", [ { condition: false, action: "{ToolTip}default" }
                              , { condition: "ahk_exe notepad.exe", action: "{ToolTip}notepad" }
                              , { condition: "ahk_exe chrome.exe", action: "{ToolTip}chrome" } ]).on()
