#Include %A_LineFile%\..\..\..\src\CustomHotkey.ahk

global a := "abC"
util := CustomHotkey.Util
util.assert(util.templateString("{a}") == "abC")
util.assert(util.templateString("{a:U}") == "ABC")
util.assert(util.templateString("{a:L}") == "abc")
util.assert(util.templateString("{a:T}") == "Abc")
util.assert(util.templateString("{:SL}", "AbcAbc") == "abc_abc")
util.assert(util.templateString("{:KL}", "AbcAbc") == "abc-abc")
util.assert(util.templateString("{:C}", "abc-abc") == "AbcAbc")
util.assert(util.templateString("{v:T}", { v: "c"}) == "C")
util.assert(util.templateString("{}", "c") == "c")
; util.assert(util.template("{{SelectedText}:U}") == "ABC")
ExitApp