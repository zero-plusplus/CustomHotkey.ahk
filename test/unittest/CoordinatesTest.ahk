#Include %A_LineFile%\..\..\..\src\CustomHotkey.ahk

util := CustomHotkey.Util

coord_monitors := new util.Coordinates(0, 0, "monitors")
util.assert(coord_monitors.x == 0)
util.assert(coord_monitors.y == 0)

coord_monitors_bottom_right := new util.Coordinates(0, 0, "monitors-bottom-right")
util.assert(coord_monitors_bottom_right.x == 1920)
util.assert(coord_monitors_bottom_right.y == 2160)

coord_window := new util.Coordinates(0, 0, "window")
WinGetPos, x, y, width, height, A
util.assert(coord_window.x == x)
util.assert(coord_window.y == y)

coord_window_bottom_right := new util.Coordinates(0, 0, "window-bottom-right")
util.assert(coord_window_bottom_right.x == x + width)
util.assert(coord_window_bottom_right.y == y + height)
ExitApp
