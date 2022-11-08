#Include %A_LineFile%\..\..\..\src\CustomHotkey.ahk

util := CustomHotkey.Util

rect_a := util.createCustomRect({ x: 0, y: 0, width: 30, height: 30 })
rect_b := util.createCustomRect([ [ 0, 0 ], [ 30, 30 ] ])
rect_c := util.createCustomRect([ { x: 0, y: 0 }, { x: 30, y: 30 } ])

util.assert(rect_a.contains(rect_b))
util.assert(rect_b.contains(rect_c))
util.assert(rect_c.contains(rect_a))

monitor_primary := util.createCustomRect("monitor-primary")
util.assert(monitor_primary.contains([ [ 0, 0 ], [ 1920, 1080 ] ]))

; Test with maximized window
window := util.createCustomRect("window")
WinGetPos, x, y, width, height, A
util.assert(window.contains({ x: x, y: y, width: width, height: height }))
ExitApp