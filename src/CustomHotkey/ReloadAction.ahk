class ReloadAction extends CustomHotkey.ActionBase {
  static defaultOptions := { tip: { id: "", x: 0, y: 0, origin: "", displayTime: "1s" }
                           , replace: false }
  static prefixRegex := "i)^(?<prefix>{(?<mode>Reload)(?:\|(?<options>[^\r\n}]+))?})"
  /**
   * @static
   * @param {string} data
   * @return {boolean}
   */
  isActionData(data) {
    if (!IsObject(data)) {
      return data ~= CustomHotkey.ReloadAction.prefixRegex
    }
    return IsObject(data) && ObjHasKey(data, "reload")
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.ReloadAction.defaultOptions}
   */
  normalizeActionData(data) {
    if (!IsObject(data)) {
      prefixRegex := CustomHotkey.ReloadAction.prefixRegex
      match := CustomHotkey.Util.regexMatch(data, prefixRegex)
      if (!match) {
        return this.setDefaultOptions({ reload: data })
      }

      data := { reload: RegExReplace(data, prefixRegex, "") }
      data.mode := match.mode
      if (match.options != "") {
        defaultOptions := CustomHotkey.ReloadAction.defaultOptions
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
      ? CustomHotkey.Util.templateString(data.reload)
      : data.reload
    if (message != "") {
      tip := new CustomHotkey.Util.ToolTip()

      data.tip.wait := true
      if (data.tip.displayTime == 0) {
        data.tip.displayTime := 1000
      }
      tip.show(message, data.tip)
    }

    Reload
  }
}