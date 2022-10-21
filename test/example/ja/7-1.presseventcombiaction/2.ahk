#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { single: [ "{ToolTip}IME OFF", { ime: false } ]
                              , "double|T1s N": [ "{ToolTip}IME ON", { ime: true } ] }).on()
