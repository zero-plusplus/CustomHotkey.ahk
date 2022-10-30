class ToolTipAction extends CustomHotkey.ActionBase {
  static defaultOptions := { tooltip: ""
                           , id: ""
                           , x: 0
                           , y: 0
                           , origin: ""
                           , displayTime: "1s" }
  static prefixRegex := "i)^(?<prefix>{(?<mode>(ToolTip)+)(?:\|(?<options>[^\r\n}]+))?})"
  /**
   * @static
   * @param {string} data
   * @return {boolean}
   */
  isActionData(data) {
    if (!IsObject(data)) {
      return data ~= CustomHotkey.ToolTipAction.prefixRegex
    }
    return ObjHasKey(data, "tooltip")
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.ToolTipAction.defaultOptions}
   */
  normalizeActionData(data) {
    if (!IsObject(data)) {
      prefixRegex := CustomHotkey.ToolTipAction.prefixRegex
      match := CustomHotkey.Util.regexMatch(data, prefixRegex)
      if (!match) {
        return this.initActionData({ tooltip: data })
      }

      data := { tooltip: RegExReplace(data, prefixRegex, "") }
      if (match.options) {
        defaultOptions := CustomHotkey.ToolTipAction.defaultOptions
        optionDefinitionMap := { "R": { name: "replace", type: "boolean", default: defaultOptions.replace }
                               , "T": { name: "displayTime", type: "time", default: defaultOptions.displayTime }
                               , "X": { name: "x", type: "number", default: defaultOptions.x }
                               , "Y": { name: "y", type: "number", default: defaultOptions.y }
                               , "O": { name: "origin", type: "string", default: defaultOptions.origin }
                               , "I": { name: "id", type: "number", default: defaultOptions.id } }
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

    if (data.tooltip == "" || CustomHotkey.Util.isPureNumber(data.tooltip) && data.tooltip == 0) {
      ToolTip, , , , % data.id
      return
    }

    tip := new CustomHotkey.Util.ToolTip(data.id)
    message := data.replace
      ? CustomHotkey.Util.templateString(data.tooltip)
      : data.tooltip
    tip.show(message, data)
  }
}