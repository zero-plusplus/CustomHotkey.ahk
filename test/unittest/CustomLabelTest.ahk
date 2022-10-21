#Include %A_LineFile%\..\..\..\src\CustomHotkey.ahk

util := CustomHotkey.Util
CustomLabel := CustomHotkey.CustomLabel
CustomLabel.clear()

CustomLabel.add("A", "vk1c")
util.assert(CustomLabel.getKeyCode("A"))
CustomLabel.remove("A")
util.assert(!CustomLabel.getKeyCode("A"))

CustomLabel.add("A", "vk1c")
util.assert(CustomLabel.getLabel("vk1c"))
CustomLabel.remove("A")
util.assert(!CustomLabel.getKeyCode("A"))

CustomLabel.add("A", "vk1c")
rawTrigger := "A & c"
replacedTrigger := CustomLabel.replace(rawTrigger)
util.assert(replacedTrigger == "vk1c & c")
util.assert(CustomLabel.revert(replacedTrigger) == rawTrigger)
ExitApp