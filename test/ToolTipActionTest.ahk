#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { tooltip: "This message is displayed for 3 seconds.", displayTime: "3s" }).on()
new CustomHotkey("RCtrl & 2", { tooltip: "This message is always displayed.", displayTime: 0, id: 19 }).on()
new CustomHotkey("RCtrl & 3", { tooltip: "", id: 19 }).on()
new CustomHotkey("RCtrl & 4", { tooltip: false, id: 19 }).on()
new CustomHotkey("RCtrl & 5", { tooltip: "0", id: 19 }).on()
new CustomHotkey("RCtrl & 6", [ { tooltip: "a" }, { tooltip: "b", x: 50, y: 50, origin: "window" } ]).on()

new CustomHotkey("RCtrl & q", "{ToolTip|T3s}This message is displayed for 3 seconds.").on()
new CustomHotkey("RCtrl & w", "{ToolTip|T0 I19}This message is always displayed.").on()
new CustomHotkey("RCtrl & e", "{ToolTip|T0 I19}").on()
new CustomHotkey("RCtrl & r", [ "{ToolTip}a", "{ToolTip|x50 y50 Owindow}b" ]).on()

new CustomHotkey("RCtrl & a", [ "{ToolTip|T-3s}a", "{ToolTip}b" ]).on()
