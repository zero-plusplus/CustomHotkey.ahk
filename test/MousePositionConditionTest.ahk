#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

CustomHotkey.MousePositionCondition.edgeSize := 40
CustomHotkey.ToolTipAction.defaultOptions.id := 1
CustomHotkey.ToolTipAction.defaultOptions.displayTime := 0

new CustomHotkey("LButton", "{ToolTip|Oscreen-1}Clicked top-left-corner in screen1", { mousepos: "screen-1-top-left-corner", target: 1 }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-1}Clicked top in screen1", { mousepos: "screen-1-top-edge", target: 1 }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-1}Clicked top-right-corner in screen1", { mousepos: "screen-1-top-right-corner", target: 1 }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-1}Clicked left in screen1", { mousepos: "screen-1-left-edge", target: 1 }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-1}Clicked right in screen1", { mousepos: "screen-1-right-edge", target: 1 }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-1}Clicked bottom-left-corner in screen1", { mousepos: "screen-1-bottom-left-corner", target: 1 }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-1}Clicked bottom in screen1", { mousepos: "screen-1-bottom-edge", target: 1 }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-1}Clicked bottom-right-corner in screen1", { mousepos: "screen-1-bottom-right-corner", target: 1 }).on()

new CustomHotkey("LButton", "{ToolTip|Oscreen-2}Clicked top-left-corner in primary screen", { mousepos: "screen-primary-top-left-corner", target: 1 }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-2}Clicked top in primary screen", { mousepos: "screen-primary-top-edge", target: 1 }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-2}Clicked top-right-corner in primary screen", { mousepos: "screen-primary-top-right-corner", target: 1 }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-2}Clicked left in primary screen", { mousepos: "screen-primary-left-edge", target: 1 }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-2}Clicked right in primary screen", { mousepos: "screen-primary-right-edge", target: 1 }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-2}Clicked bottom-left-corner in primary screen", { mousepos: "screen-primary-bottom-left-corner", target: 1 }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-2}Clicked bottom in primary screen", { mousepos: "screen-primary-bottom-edge" }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-2}Clicked bottom-right-corner in primary screen", { mousepos: "screen-primary-bottom-right-corner", target: 1 }).on()