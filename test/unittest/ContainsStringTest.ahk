#Include %A_LineFile%\..\..\..\src\CustomHotkey.ahk

util := CustomHotkey.Util
util.assert(util.containsString("abcdef", "bc"))
util.assert(!util.containsString("abcdef", "BC"))
util.assert(util.containsString("abcdef", "BC", true))
ExitApp