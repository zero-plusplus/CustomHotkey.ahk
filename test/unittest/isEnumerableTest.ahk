#Include %A_LineFile%\..\..\..\src\CustomHotkey.ahk

util := CustomHotkey.Util
util.assert(util.isEnumerable({}))
util.assert(util.isEnumerable(T))
util.assert(!util.isEnumerable(Func("SubStr")))
util.assert(!util.isEnumerable(ObjBindMethod(T, "method")))
ExitApp

class T {
  method() {
  }
}