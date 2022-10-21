#Include %A_LineFile%\..\..\..\src\CustomHotkey.ahk

util := CustomHotkey.Util
util.assert(util.startsWith("abcdef", "abc"))
util.assert(!util.startsWith("abcdef", "ABC"))
util.assert(util.startsWith("abcdef", "ABC", true))
ExitApp