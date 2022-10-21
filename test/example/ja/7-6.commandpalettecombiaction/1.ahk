#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { items: [ { command: "copy"
                                         , description: "選択テキストをコピー"
                                         , action: "^c" }
                                       , { command: "cut"
                                         , description: "選択テキストをカット"
                                         , action: "^x" }
                                       , { command: "paste"
                                         , description: "ペースト"
                                         , action: "^v" } ] }).on()
