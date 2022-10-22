#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "{TrayTip|TInfo Iinfo}情報アイコン付きのトレイチップを表示").on()
