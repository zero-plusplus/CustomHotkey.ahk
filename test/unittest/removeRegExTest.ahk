#Include %A_LineFile%\..\..\..\src\CustomHotkey.ahk

util := CustomHotkey.Util
util.assert(util.removeRegexFlags("abc", "i") == "abc")
util.assert(util.removeRegexFlags(")abc", "i") == ")abc")
util.assert(util.removeRegexFlags("i)abc", "i") == ")abc")
util.assert(util.removeRegexFlags("im)abc", "i") == "m)abc")
ExitApp