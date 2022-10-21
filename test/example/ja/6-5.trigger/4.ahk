#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

CustomHotkey.CustomLabel.add("変換", "vk1c")
CustomHotkey.CustomLabel.add("Convert", "vk1c")

new CustomHotkey("Convert", items).on()
; 以下はエラーになります
new CustomHotkey("変換", items).on()
