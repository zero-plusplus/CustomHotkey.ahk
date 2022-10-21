#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RShift & LShift", { q: "^{c}" , w: "^{x}", "e|R10ms": "^{v}" }).on()
new CustomHotkey("RCtrl & a", "{ToolTip}A").on()
new CustomHotkey("RCtrl & LCtrl", { release: "{ToolTip|T-1s}Trigger-release"
                                  , keyRepeat: false
                                  , "a|R10ms": "{A}"
                                  , q: { w: { e: "{ToolTip|T-1s}Trigger + q + w + e" } }
                                  , c: "{ToolTip|T-1s}Trigger + c" } ).on()
new CustomHotkey("w", "w").on()
new CustomHotkey("z", "z").on()
new CustomHotkey("m & l", { release: "{ToolTip|T-1s}Trigger-release"
                          , keyRepeat: "30ms"
                          , w: "{W}"
                          , s: "{S}"
                          , a: { x: 150, y: 0 }
                          , r: "{ToolTip|T-1s}Trigger + r"
                          , f: "{ToolTip|T-1s}Trigger + f" }).on()
new CustomHotkey("PgUp & PgDn", { q: { w: { "e|R10ms": "{ToolTip}PgUp & PgDn & q & w & e" } } }).on()
