﻿#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "{ToolTip}メモ帳はアクティブです", { active: { exe: "notepad.exe" } }).on()
