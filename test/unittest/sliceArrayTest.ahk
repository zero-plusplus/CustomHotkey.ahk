#Include %A_LineFile%\..\..\..\src\CustomHotkey.ahk

util := CustomHotkey.Util
sliced_1 := util.sliceArray([ "1", "2", "3"], 1, 3)
util.assert(sliced_1[1] == "1")
util.assert(sliced_1[2] == "2")
util.assert(sliced_1[3] == "3")

sliced_2 := util.sliceArray([ "1", "2", "3"], 2, 2)
util.assert(sliced_2[1] == "2")

sliced_3 := util.sliceArray([ "1", "2", "3"], 2, 10)
util.assert(sliced_3[1] == "2")
util.assert(sliced_3[2] == "3")
util.assert(sliced_3.length() == 2)
ExitApp