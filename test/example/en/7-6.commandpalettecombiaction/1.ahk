#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { items: [ { command: "copy"
                                         , description: "Copy selected text"
                                         , action: "^c" }
                                       , { command: "cut"
                                         , description: "Cut selected text"
                                         , action: "^x" }
                                       , { command: "paste"
                                         , description: "Paste clipboard contents"
                                         , action: "^v" } ] }).on()
