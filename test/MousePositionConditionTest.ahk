#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

CustomHotkey.MousePositionCondition.edgeSize := 40
CustomHotkey.ToolTipAction.defaultOptions.id := 1
CustomHotkey.ToolTipAction.defaultOptions.displayTime := 0

new CustomHotkey("LButton", "{ToolTip|Oscreen-1}Clicked top-left-corner in screen1", { mousepos: "screen-1-top-left-corner" }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-1}Clicked top in screen1", { mousepos: "screen-1-top-edge" }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-1}Clicked top-right-corner in screen1", { mousepos: "screen-1-top-right-corner" }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-1}Clicked left in screen1", { mousepos: "screen-1-left-edge" }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-1}Clicked right in screen1", { mousepos: "screen-1-right-edge" }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-1}Clicked bottom-left-corner in screen1", { mousepos: "screen-1-bottom-left-corner" }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-1}Clicked bottom in screen1", { mousepos: "screen-1-bottom-edge" }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-1}Clicked bottom-right-corner in screen1", { mousepos: "screen-1-bottom-right-corner" }).on()

new CustomHotkey("LButton", "{ToolTip|Oscreen-2}Clicked top-left-corner in primary screen", { mousepos: "screen-primary-top-left-corner" }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-2}Clicked top in primary screen", { mousepos: "screen-primary-top-edge" }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-2}Clicked top-right-corner in primary screen", { mousepos: "screen-primary-top-right-corner" }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-2}Clicked left in primary screen", { mousepos: "screen-primary-left-edge" }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-2}Clicked right in primary screen", { mousepos: "screen-primary-right-edge" }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-2}Clicked bottom-left-corner in primary screen", { mousepos: "screen-primary-bottom-left-corner" }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-2}Clicked bottom in primary screen", { mousepos: "screen-primary-bottom-edge" }).on()
new CustomHotkey("LButton", "{ToolTip|Oscreen-2}Clicked bottom-right-corner in primary screen", { mousepos: "screen-primary-bottom-right-corner" }).on()

new CustomHotkey("RButton", "{ToolTip|Oscreens}Clicked top-left-corner in screens", { mousepos: "screens-top-left-corner" }).on()
new CustomHotkey("RButton", "{ToolTip|Oscreens}Clicked top in screens", { mousepos: "screens-top-edge" }).on()
new CustomHotkey("RButton", "{ToolTip|Oscreens}Clicked top-right-corner in screens", { mousepos: "screens-top-right-corner" }).on()
new CustomHotkey("RButton", "{ToolTip|Oscreens}Clicked left in screens", { mousepos: "screens-left-edge" }).on()
new CustomHotkey("RButton", "{ToolTip|Oscreens}Clicked right in screens", { mousepos: "screens-right-edge" }).on()
new CustomHotkey("RButton", "{ToolTip|Oscreens}Clicked bottom-left-corner in screens", { mousepos: "screens-bottom-left-corner" }).on()
new CustomHotkey("RButton", "{ToolTip|Oscreens}Clicked bottom in screens", { mousepos: "screens-bottom-edge" }).on()
new CustomHotkey("RButton", "{ToolTip|Oscreens}Clicked bottom-right-corner in screens", { mousepos: "screens-bottom-right-corner" }).on()