#Include %A_LineFile%\..\..\..\src\CustomHotkey.ahk

global a := "abC"
util := CustomHotkey.Util
util.assert(util.toSnakeCase("AbcAbc") == "abc_abc")
util.assert(util.toSnakeCase("Abc-Abc") == "abc_abc")
util.assert(util.toSnakeCase("Abc_Abc") == "abc_abc")
util.assert(util.toSnakeCase("Abc Abc") == "abc_abc")
ExitApp