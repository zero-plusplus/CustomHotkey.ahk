#Include %A_LineFile%\..\..\..\src\CustomHotkey.ahk

util := CustomHotkey.Util
util.assert(util.endsWith("abcdef", "def"))
util.assert(!util.endsWith("abcdef", "DEF"))
util.assert(util.endsWith("abcdef", "DEF", true))
ExitApp