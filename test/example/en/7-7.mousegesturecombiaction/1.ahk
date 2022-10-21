#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RButton", { items: [ { gestures: [ "MoveUp", "MoveRight", "MoveDown", "MoveLeft" ]
                                       , description: "↑→↓←"
                                       , action: "{ToolTip}↑→↓←" }
                                     , { gestures: [ "MoveUp", "MoveDown" ]
                                       , description: "↑↓"
                                       , action: "{ToolTip}↑↓" } ] }).on()
new CustomHotkey("RCtrl & Up", { items: [ { gestures: [ "LButton", "RButton", "MButton", "XButton1", "XButton2" ]
                                          , action: "{ToolTip}Pressed all mouse buttons" } ] }).on()
