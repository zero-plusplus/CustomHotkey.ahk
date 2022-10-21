#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true
CustomHotkey.debugOptions.enableConditionLog := true

new CustomHotkey("RCtrl & 1", "{Paste} := ", { active: { exe: "Code.exe", title: "^[^-]+\.(ahk|ahk2|ah2)" }
                                             , matchMode: "regex" }).on()
new CustomHotkey("RCtrl & 1", "{Paste} = ", { exe: "Code.exe" }).on()
new CustomHotkey("RCtrl & 2", "{ToolTip}AAA", { matchMode: "partial", detectHidden: true, exist: { class: "AutoHotkey", title: "WindowConditionTest.ahk" } }).on()
new CustomHotkey("RCtrl & 4", "{ToolTip}Detected another AutoHotkey", { matchMode: "partial", detectHidden: true, exist: { class: "AutoHotkey", excludeTitle: A_ScriptFullPath } }).on()
new CustomHotkey("RCtrl & 4", "{ToolTip}Don't detected another AutoHotkey").on()

new CustomHotkey("RCtrl & q", "{Paste} := ", "{Active|Mregex}^[^-]+\.(ahk|ahk2|ah2) ahk_exe Code.exe").on()
new CustomHotkey("RCtrl & q", "{Paste} = ", "{Active}ahk_exe Code.exe").on()
new CustomHotkey("RCtrl & w", "{ToolTip}AAA", "{Exist|Mpartial D}WindowConditionTest.ahk ahk_class AutoHotkey").on()

new CustomHotkey("RCtrl & a", "{ToolTip}Notepad is activated", "{Exist|Mpartial D}ahk_exe notepad.exe").on()
