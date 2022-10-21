#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { single: "{ToolTip}single"
                              , long: "{ToolTip}long"
                              , double: { single: "{ToolTip}double"
                                        , long: "{ToolTip}double+long"
                                        , double: { single: "{ToolTip}triple"
                                                  , long: "{ToolTip}triple+long"
                                                  , double: { single: "{ToolTip}quadruple"
                                                            , long: "{ToolTip}quadruple+long"
                                                            , double: { single: "{ToolTip}quintuple"
                                                                      , long: "{ToolTip}quintuple+long" } } } } }).on()
