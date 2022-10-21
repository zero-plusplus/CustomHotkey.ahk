#Include %A_LineFile%\..\..\..\src\CustomHotkey.ahk

util := CustomHotkey.Util
util.assert(util.deepEquals([ 1 ], [ 1 ]))
util.assert(util.deepEquals([ 1, [ 1 ] ], [ 1, [ 1 ] ]))
util.assert(!util.deepEquals([ 1 ], [ 2 ]))
util.assert(util.deepEqualsIgnoreCase( [ "MoveLeft", "MoveUp", "MoveRight", "MoveDown", "MoveLeft" ]
                                     , [ "MoveLeft", "MoveUp", "MoveRight", "MoveDown", "MoveLeft" ] ))
ExitApp