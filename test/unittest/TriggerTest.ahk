#Include %A_LineFile%\..\..\..\src\CustomHotkey.ahk

util := CustomHotkey.Util

trigger_a := new CustomHotkey.Trigger("*~$+^c")
util.assert(!trigger_a.isCombination)
util.assert(trigger_a.prefixSymbols[1] == "*")
util.assert(trigger_a.prefixSymbols[2] == "~")
util.assert(trigger_a.prefixSymbols[3] == "$")
util.assert(trigger_a.modifiers[1] == "Shift")
util.assert(trigger_a.modifiers[2] == "Ctrl")
util.assert(trigger_a.prefixKey == "")
util.assert(trigger_a.key == "c")
util.assert(trigger_a.secondKey == "c")

trigger_b := new CustomHotkey.Trigger("vk1d & c up")
util.assert(trigger_b.isCombination)
util.assert(trigger_b.prefixSymbols.length() == 0)
util.assert(trigger_b.prefixKey == "vk1d")
util.assert(trigger_b.modifiers[1] == "vk1d")
util.assert(trigger_b.key == "c")
util.assert(trigger_b.secondKey == "c")
util.assert(trigger_b.isReleaseMode)
ExitApp