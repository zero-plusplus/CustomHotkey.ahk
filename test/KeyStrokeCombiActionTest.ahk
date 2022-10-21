#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { autoKeys: [ "a", "b", "c"]
                              , items: [ { key: "$", desc: "a", action: "{ToolTip}a" }
                                       , { key: "$", desc: "b", action: "{ToolTip}b" }
                                       , { key: "$", desc: "c", action: "{ToolTip}c" } ] }).on()

new CustomHotkey("RCtrl & 2", [ { key: "c", desc: "copy", action: "^{c}" }
                              , { key: "x", desc: "cut", action: "^{x}" }
                              , { key: "v", desc: "paste", action: "^{v}" } ]).on()

new CustomHotkey("RCtrl & 3", [ { key: "$", desc: "1", action: "{ToolTip}1" }
                              , { key: "$", desc: "2", action: "{ToolTip}2" }
                              , { key: "$", desc: "3", action: "{ToolTip}3" }
                              , { key: "F$", desc: "F1", action: "{ToolTip}F1" }
                              , { key: "F$", desc: "F2", action: "{ToolTip}F2" }
                              , { key: "F$", desc: "F3", action: "{ToolTip}F3" } ]).on()

new CustomHotkey("RCtrl & 4", [ { key: "a"
                                , action: [ { key: "b"
                                            , action: [ { key: "c"
                                                        , action: "{ToolTip}abc" } ] } ] } ]).on()

new CustomHotkey("z", { single: "z", long: "Z" }).on()
new CustomHotkey("c", { single: "c", long: "C" }).on()
new CustomHotkey("d", "v").on()
items := [ { key: "z", action: "{ToolTip}z" }
         , { key: "c", action: "{ToolTip}c" }
         , { key: "d", action: "{ToolTip}d" } ]
new CustomHotkey("RCtrl & 5", items).on()
new CustomHotkey("RCtrl & 6", new CustomHotkey.KeyStrokeCombiAction(items)).on()

new CustomHotkey("RCtrl & q", [ { key: "vk5a", action: "{ToolTip}z" } ]).on()
