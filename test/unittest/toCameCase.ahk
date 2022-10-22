#Include %A_LineFile%\..\..\..\src\CustomHotkey.ahk

global a := "abC"
util := CustomHotkey.Util
util.assert(util.toCamelCase("AbcAbc") == "AbcAbc")
util.assert(util.toCamelCase("Abc-Abc") == "AbcAbc")
util.assert(util.toCamelCase("Abc_Abc") == "AbcAbc")
util.assert(util.toCamelCase("Abc Abc") == "AbcAbc")
ExitApp