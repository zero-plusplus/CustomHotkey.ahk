#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { single: "{ToolTip}単押し"
                              , long: "{ToolTip}長押し"
                              , double: { single: "{ToolTip}2度押し"
                                        , long: "{ToolTip}2度押し+長押し"
                                        , double: { single: "{ToolTip}3度押し"
                                                  , long: "{ToolTip}3度押し+長押し"
                                                  , double: { single: "{ToolTip}4度押し"
                                                            , long: "{ToolTip}4度押し+長押し"
                                                            , double: { single: "{ToolTip}5度押し"
                                                                      , long: "{ToolTip}5度押し+長押し" } } } } }).on()
