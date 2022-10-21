#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true
CustomHotkey.ToolTipAction.defaultOptions.displayTime := "-1s"

new CustomHotkey("RCtrl & 1", { single: "{ToolTip}single"
                              , "long|T1s": "{ToolTip}long"
                              , "double|T200ms": "{ToolTip}double" } ).on()
new CustomHotkey("RCtrl & 2", { single: "{ToolTip}single"
                              , long: "{ToolTip}long"
                              , double: { single: "{ToolTip}double"
                                        , long: "{ToolTip}double+long"
                                        , double: { single: "{ToolTip}triple"
                                                  , long: "{ToolTip}triple+long"
                                                  , double: { single: "{ToolTip}quadruple"
                                                            , long: "{ToolTip}quadruple+long"
                                                            , double: { single: "{ToolTip}quintuple"
                                                                      , long: "{ToolTip}quintuple+long" } } } } }).on()
new CustomHotkey("RCtrl & 3", { single: "{ToolTip}single"
                              , long: "{ToolTip}long"
                              , "double|T500ms": "{ToolTip}double"
                              , triple: "{ToolTip}triple"
                              , quadruple: "{ToolTip}quadruple"
                              , quintuple: { single: "{ToolTip}quintuple", double: "{ToolTip}sextuple" } }).on()
new CustomHotkey("RCtrl & 4", { single: "{ToolTip}single"
                              , long: "{ToolTip}long"
                              , "double|T500ms N": "{ToolTip}double"
                              , triple: "{ToolTip}triple" }).on()
new CustomHotkey("RCtrl & 5", { single: [ "{ToolTip|I1}IME OFF", { ime: false } ]
                              , "double|T1s N": [ "{ToolTip|I1}IME ON", { ime: true } ] }).on()

new CustomHotkey("RCtrl & q", [ { key: "a", action: { single: "{ToolTip}single"
                                                    , long: "{ToolTip}long"
                                                    , double: "{ToolTip}double"
                                                    , triple: "{ToolTip}triple"
                                                    , quadruple: "{ToolTip}quadruple"
                                                    , quintuple: { single: "{ToolTip}quintuple", double: "{ToolTip}sextuple" } } } ]).on()

; Note: Does not work correctly long press for virtual modifier keys
new CustomHotkey("Up & Down", "{ToolTip}up & down").on()
new CustomHotkey("Up", { single: "{ToolTip}single"
                       , long: "{ToolTip}long"
                       , double: "{ToolTip}double" }).on()