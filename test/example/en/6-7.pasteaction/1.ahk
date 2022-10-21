#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

; Output the `"abc"`
new CustomHotkey("RCtrl & 1", "{Paste}abc").on()

; Enclose the selected string in parentheses
new CustomHotkey("RCtrl & 2", "{Paste|R}({{SelectedText}})").on()

; Output today's date
new CustomHotkey("RCtrl & 3", "{Paste|R}{A_YYYY}/{A_MM}/{A_DD}").on()
