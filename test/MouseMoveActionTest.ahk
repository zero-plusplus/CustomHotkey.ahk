#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { x: 100, speed: 0 }).on()
new CustomHotkey("RCtrl & 2", { x: -100, y: -100, origin: { x: 200, y: 200 } }).on()
new CustomHotkey("RCtrl & 3", [ { origin: "window", speed: 10 }
                              , { origin: "window-top-center", speed: 10 }
                              , { origin: "window-top-right", speed: 10 }
                              , { origin: "window-middle-right", speed: 10 }
                              , { origin: "window-bottom-right", speed: 10 }
                              , { origin: "window-bottom-center", speed: 10 }
                              , { origin: "window-bottom-left", speed: 10 }
                              , { origin: "window-middle-left", speed: 10 }
                              , { origin: "window-center", speed: 10 } ]).on()
new CustomHotkey("RCtrl & 4", [ { origin: "screen-1-top-left", speed: 10 }
                              , { origin: "screen-1-top-center", speed: 10 }
                              , { origin: "screen-1-top-right", speed: 10 }
                              , { origin: "screen-1-middle-right", speed: 10 }
                              , { origin: "screen-1-bottom-right", speed: 10 }
                              , { origin: "screen-1-bottom-center", speed: 10 }
                              , { origin: "screen-1-bottom-left", speed: 10 }
                              , { origin: "screen-1-middle-left", speed: 10 }
                              , { origin: "screen-1-center", speed: 10 } ]).on()
new CustomHotkey("RCtrl & 5", [ { origin: "screen-2-top-left", speed: 10 }
                              , { origin: "screen-2-top-center", speed: 10 }
                              , { origin: "screen-2-top-right", speed: 10 }
                              , { origin: "screen-2-middle-right", speed: 10 }
                              , { origin: "screen-2-bottom-right", speed: 10 }
                              , { origin: "screen-2-bottom-center", speed: 10 }
                              , { origin: "screen-2-bottom-left", speed: 10 }
                              , { origin: "screen-2-middle-left", speed: 10 }
                              , { origin: "screen-2-center", speed: 10 } ]).on()
new CustomHotkey("RCtrl & 6", [ { origin: "mouse-bottom-left", speed: 10 } ]).on()
new CustomHotkey("RCtrl & 7", [ { origin: "caret", speed: 10 }
                              , { origin: "caret-top-center", speed: 10 }
                              , { origin: "caret-top-right", speed: 10 }
                              , { origin: "caret-middle-right", speed: 10 }
                              , { origin: "caret-bottom-right", speed: 10 }
                              , { origin: "caret-bottom-center", speed: 10 }
                              , { origin: "caret-bottom-left", speed: 10 }
                              , { origin: "caret-middle-left", speed: 10 }
                              , { origin: "caret-center", speed: 10 } ]).on()
