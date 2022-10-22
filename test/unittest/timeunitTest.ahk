#Include %A_LineFile%\..\..\..\src\CustomHotkey.ahk

util := CustomHotkey.Util
util.assert(util.timeunit(123) == 123)
util.assert(util.timeunit("1000ms", "ms") == 1000)
util.assert(util.timeunit("1000ms", "s") == 1)
util.assert(util.timeunit("1s", "s") == 1)
util.assert(util.timeunit("1s", "ms") == 1000)
util.assert(util.timeunit("1h", "m") == 60)
util.assert(util.timeunit("60m", "h") == 1)
util.assert(util.timeunit("60s", "m") == 1)
util.assert(util.timeunit("1h", "ms") == 3600000)
ExitApp