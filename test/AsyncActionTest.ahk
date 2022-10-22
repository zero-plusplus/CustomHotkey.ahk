#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", [ { async: "a", delay: 250 }
                              , { async: "b" }
                              , { async: "c", delay: 150 } ]).on()
