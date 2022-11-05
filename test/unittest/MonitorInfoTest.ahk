#Include %A_LineFile%\..\..\..\src\CustomHotkey.ahk

util := CustomHotkey.Util
MonitorInfo := util.MonitorInfo

; The following is a test on my monitoring environment
monitor1 := new MonitorInfo(1)
util.assert(monitor1.number == 1)
util.assert(monitor1.rect.x == 0)
util.assert(monitor1.rect.y == 1080)
util.assert(monitor1.rect.width == 1920)
util.assert(monitor1.rect.height == 1080)

monitor2 := new MonitorInfo(2)
util.assert(monitor2.number == 2)
util.assert(monitor2.rect.x == 0)
util.assert(monitor2.rect.y == 0)
util.assert(monitor2.rect.width == 1920)
util.assert(monitor2.rect.height == 1080)
ExitApp