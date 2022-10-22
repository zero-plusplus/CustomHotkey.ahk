#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", { traytip: "This message is displayed.", title: "Title" }).on()
new CustomHotkey("RCtrl & 2", { traytip: "No sound", silent: true }).on()
new CustomHotkey("RCtrl & 3", { traytip: "Infomation", icon: "info" }).on()
new CustomHotkey("RCtrl & 4", { traytip: "Warning", icon: "warn" }).on()
new CustomHotkey("RCtrl & 5", { traytip: "Error", icon: "error" }).on()

new CustomHotkey("RCtrl & q", "{TrayTip|TTitle}This message is displayed.").on()
new CustomHotkey("RCtrl & w", "{TrayTip|S}No sound").on()
new CustomHotkey("RCtrl & e", "{TrayTip|Iinfo}Infomation").on()
new CustomHotkey("RCtrl & r", "{TrayTip|Iwarn}Warning").on()
new CustomHotkey("RCtrl & t", "{TrayTip|Ierror}Error").on()
