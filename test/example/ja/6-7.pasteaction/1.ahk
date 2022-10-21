#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

; 文字を出力する
new CustomHotkey("RCtrl & 1", "{Paste}abc").on()

; 選択している文字列を括弧で囲う
new CustomHotkey("RCtrl & 2", "{Paste|R}({{SelectedText}})").on()

; 今日の日付を出力する
new CustomHotkey("RCtrl & 3", "{Paste|R}{A_YYYY}/{A_MM}/{A_DD}").on()
