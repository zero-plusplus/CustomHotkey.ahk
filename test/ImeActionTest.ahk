#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { trigger: [ { ime: false }, { tooltip: "OFF", displayTime: "0.5s" } ]
                              , shift: [ { ime: true }, { tooltip: "ON", displayTime: "0.5s" } ] }).on()
new CustomHotkey("RCtrl & 2", [ { ime: true }, { tooltip: "ON", displayTime: "0.5s"} ]).on()
