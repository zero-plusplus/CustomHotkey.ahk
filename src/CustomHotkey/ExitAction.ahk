class ExitAction extends CustomHotkey.ActionBase {
  static defaultOptions := { tip: { id: "", x: 0, y: 0, origin: "", displayTime: "1s" }
                           , replace: false }
  static prefixRegex := "i)^(?<prefix>{(?<mode>Exit)(?:\|(?<options>[^\r\n}]+))?})"
  /**
   * @static
   * @param {string} data
   * @return {boolean}
   */
  isActionData(data) {
    if (!IsObject(data)) {
      return return data ~= CustomHotkey.ExitAction.prefixRegex
    }
    return IsObject(data) && ObjHasKey(data, "exit")
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.ExitAction.defaultOptions}
   */
  normalizeActionData(data) {
    if (!IsObject(data)) {
      prefixRegex := CustomHotkey.ExitAction.prefixRegex
      match := CustomHotkey.Util.regexMatch(data, prefixRegex)
      if (!match) {
        return this.setDefaultOptions({ exit: data })
      }

      data := { exit: RegExReplace(data, prefixRegex, "") }
      data.mode := match.mode
      if (match.options != "") {
        defaultOptions := CustomHotkey.ExitAction.defaultOptions
        optionDefinitionMap := { "X": { name: "tip.x", type: "number", default: defaultOptions.tip.x }
                               , "Y": { name: "tip.y", type: "number", default: defaultOptions.tip.y }
                               , "O": { name: "tip.origin", type: "string", default: defaultOptions.tip.origin }
                               , "T": { name: "tip.displayTime", type: "time", default: defaultOptions.tip.displayTime }
                               , "R": { name: "replace", type: "boolean", default: defaultOptions.replace } }
        options := CustomHotkey.Util.parseOptionsString(match.options, optionDefinitionMap)
        data := this.setDefaultOptions(data, options)
      }
    }

    data := this.setDefaultOptions(data)
    data.tip.displayTime := CustomHotkey.Util.timeunit(data.tip.displayTime, "ms")
    return data
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data

    message := data.replace
      ? CustomHotkey.Util.templateString(data.exit)
      : data.exit
    if (message != "") {
      tip := new CustomHotkey.Util.ToolTip()

      data.tip.wait := true
      if (data.tip.displayTime == 0) {
        data.tip.displayTime := 1000
      }
      tip.show(message, data.tip)
    }

    ExitApp
  }
}