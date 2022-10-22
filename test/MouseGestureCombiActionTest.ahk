#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("^LButton", [ { gestures: [ "MoveUp", "MoveRight", "MoveDown", "MoveLeft" ]
                               , description: "{ToolTip}↑→↓←"
                               , action: "{ToolTip}↑→↓←" } ] ).on()
new CustomHotkey("^RButton", [ { gestures: [ "MoveUp", "MoveRight", "MoveDown", "MoveLeft" ]
                               , description: "↑→↓←"
                               , action: "{ToolTip}↑→↓←" }
                             , { gestures: [ "MoveUp", "MoveDown", "MoveUp", "MoveDown" ]
                               , description: "↑↓↑↓"
                               , action: "{ToolTip}↑↓↑↓" } ]).on()
new CustomHotkey("XButton1 & MButton", { style: { color: "red" }, items: [ { gestures: [ "MoveUp", "MoveUp" ], action: "{ToolTip}MoveUp" } ] }).on()

new CustomHotkey("RCtrl & Up", [ { gestures: [ "MoveUp", "MoveUp" ], action: "{ToolTip}MoveUp" }
                               , { gestures: [ "MoveDown", "MoveDown" ], action: "{ToolTip}MoveDown" }
                               , { gestures: [ "MoveLeft", "MoveLeft" ], action: "{ToolTip}MoveLeft" }
                               , { gestures: [ "MoveRight", "MoveRight" ], action: "{ToolTip}MoveRight" }
                               , { gestures: [ "MoveUpLeft", "MoveUpLeft" ], action: "{ToolTip}MoveUpLeft" }
                               , { gestures: [ "MoveUpRight", "MoveUpRight" ], action: "{ToolTip}MoveUpRight" }
                               , { gestures: [ "MoveDownLeft", "MoveDownLeft" ], action: "{ToolTip}MoveDownLeft" }
                               , { gestures: [ "MoveDownRight", "MoveDownRight" ], action: "{ToolTip}MoveDownRight" }
                               , { gestures: [ "LButton", "LButton" ], action: "{ToolTip}LButton" }
                               , { gestures: [ "RButton", "RButton" ], action: "{ToolTip}RButton" }
                               , { gestures: [ "MButton", "MButton" ], action: "{ToolTip}MButton" }
                               , { gestures: [ "XButton1", "XButton1" ], action: "{ToolTip}XButton1" }
                               , { gestures: [ "XButton2", "XButton2" ], action: "{ToolTip}XButton2" } ]).on()
