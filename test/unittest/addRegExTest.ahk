#Include %A_LineFile%\..\..\..\src\CustomHotkey.ahk

util := CustomHotkey.Util
util.assert(util.addRegexFlags("abc", "i") == "i)abc")
util.assert(util.addRegexFlags(")abc", "i") == "i)abc")
util.assert(util.addRegexFlags("i)abc", "i") == "i)abc")
ExitApp