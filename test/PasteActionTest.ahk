#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "{Paste}+{abc}").on()
new CustomHotkey("RCtrl & 2", "{Paste|R}({{SelectedText}})").on()
new CustomHotkey("RCtrl & 3", "{Paste|R}{{SelectedText}:U}").on()
new CustomHotkey("RCtrl & 4", "{Paste|R}{{SelectedText}:L}").on()
new CustomHotkey("RCtrl & 5", "{Paste|R}{{SelectedText}:T}").on()
new CustomHotkey("RCtrl & 6", { trigger: "{Paste}!", shift: "{Paste|R}!{{SelectedText}}!"}).on()
new CustomHotkey("RCtrl & 7", "{Paste|R}{A_YYYY}/{A_MM}/{A_DD}").on()

new CustomHotkey("RCtrl & q", { paste: "{{SelectedText}:U}", replace: true }).on()
new CustomHotkey("RCtrl & w", { paste: "{{SelectedText}:Q}", replace: true }).on()
new CustomHotkey("RCtrl & e", [ { command: "UPPERCASE", action: "{Paste|R}{{SelectedText}:U}" }
                              , { command: "lowercase", action: "{Paste|R}{{SelectedText}:L}" }
                              , { command: "Titlecase", action: "{Paste|R}{{SelectedText}:T}" }
                              , { command: "UpperCamelCase", action: "{Paste|R}{{SelectedText}:UC}" }
                              , { command: "lowerCamelCase", action: "{Paste|R}{{SelectedText}:LC}" }
                              , { command: "lower_snake_case", action: "{Paste|R}{{SelectedText}:LS}" }
                              , { command: "UPPER_SNAKE_CASE", action: "{Paste|R}{{SelectedText}:US}" }
                              , { command: "lower_kebab_case", action: "{Paste|R}{{SelectedText}:LK}" }
                              , { command: "UPPER_KEBAB_CASE", action: "{Paste|R}{{SelectedText}:UK}" }
                              , { command: "White space case", action: "{Paste|R}{{SelectedText}:W}" }
                              , { command: "Capitalized Word", action: "{Paste|R}{{SelectedText}:WU}" }
                              , { command: "Sentence case", action: "{Paste|R}{{SelectedText}:WT}" } ]).on()

new CustomHotkey("RCtrl & z", "{Paste|C1000}abc").on()
new CustomHotkey("RCtrl & x", "{Paste|-C}abc").on()
new CustomHotkey("RCtrl & c", "{Paste|C}abc").on()

new CustomHotkey("RCtrl & r", [ "{Paste|C1000}abc", "{ToolTip}pasted" ]).on()
new CustomHotkey("RCtrl & f", [ "{Paste|C-1000ms}abc", "{ToolTip}pasted" ]).on()
