#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "{ToolTip}メモ帳は起動中です", "{Exist}ahk_exe notepad.exe").on()
