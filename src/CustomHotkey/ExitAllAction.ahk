class ExitAllAction extends CustomHotkey.ActionBase {
  static defaultOptions := { tip: { id: "", x: 0, y: 0, origin: "", displayTime: "1s" }
                           , replace: false
                           , excludeSelf: false }
  static prefixRegex := "i)^(?<prefix>{(?<mode>ExitAll)(?:\|(?<options>[^\r\n}]+))?})"
  /**
   * @static
   * @param {string} data
   * @return {boolean}
   */
  isActionData(data) {
    if (!IsObject(data)) {
      return return data ~= CustomHotkey.ExitAllAction.prefixRegex
    }
    return IsObject(data) && ObjHasKey(data, "exitAll")
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.ExitAllAction.defaultOptions}
   */
  normalizeActionData(data) {
    if (!IsObject(data)) {
      prefixRegex := CustomHotkey.ExitAllAction.prefixRegex
      match := CustomHotkey.Util.regexMatch(data, prefixRegex)
      if (!match) {
        return this.initActionData({ exitAll: data })
      }

      data := { exitAll: RegExReplace(data, prefixRegex, "") }
      data.mode := match.mode
      if (match.options != "") {
        defaultOptions := CustomHotkey.ExitAllAction.defaultOptions
        optionDefinitionMap := { "X": { name: "tip.x", type: "number", default: defaultOptions.tip.x }
                               , "Y": { name: "tip.y", type: "number", default: defaultOptions.tip.y }
                               , "O": { name: "tip.origin", type: "string", default: defaultOptions.tip.origin }
                               , "T": { name: "tip.displayTime", type: "time", default: defaultOptions.tip.displayTime }
                               , "E": { name: "excludeSelf", type: "boolean", default: defaultOptions.excludeSelf }
                               , "R": { name: "replace", type: "boolean", default: defaultOptions.replace } }
        options := CustomHotkey.Util.parseOptionsString(match.options, optionDefinitionMap)
        data := this.setDefaultOptions(data, options)
      }
    }

    data := this.setDefaultOptions(data)
    return data
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data

    message := data.replace
      ? CustomHotkey.Util.templateString(data.exitAll)
      : data.exitAll
    if (message != "") {
      tip := new CustomHotkey.Util.ToolTip()

      data.tip.wait := true
      tip.show(message, data.tip)
    }

    this._killAutoHotkeyProcesses(data.excludeSelf)
    tip.close()
  }
  /**
   * Kill all currently running AutoHotkey processes.
   * @private
   */
  _killAutoHotkeyProcesses(excludeSelf) {
    detectHiddenWindows_bk := A_DetectHiddenWindows
    DetectHiddenWindows, On

    WinGet, currentScriptPid, PID, ahk_id %A_ScriptHwnd%
    WinGet, autohotkeyList, List, ahk_exe AutoHotkey.exe

    length := autohotkeyList
    Loop %length%
    {
      hwnd := autohotkeyList%A_Index%
      WinGet, pid, PID, ahk_id %hwnd%
      if (currentScriptPid == pid) {
        continue
      }
      Process, Close, %pid%
    }

    if (!excludeSelf) {
      ExitApp
    }
    DetectHiddenWindows, %detectHiddenWindows_bk%
  }
}