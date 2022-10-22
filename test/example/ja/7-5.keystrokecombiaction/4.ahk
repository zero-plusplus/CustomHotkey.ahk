#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", [ { key: "b"
                                , desc: "by"
                                , action: [ { key: "t"
                                            , desc: "the"
                                            , action: [ { key: "w"
                                                        , desc: "way"
                                                        , action: "{ToolTip}by the way" } ] } ] } ]).on()
