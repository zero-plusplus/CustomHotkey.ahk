class TrayTipAction extends CustomHotkey.ActionBase {
  static defaultOptions := { traytip: ""
                           , replace: true
                           , title: ""
                           , icon: ""
                           , silent: false }
  static prefixRegex := "i)^(?<prefix>{(?<mode>(TrayTip)+)(?:\|(?<options>[^\r\n}]+))?})"
  /**
   * @static
   * @param {string} data
   * @return {boolean}
   */
  isActionData(data) {
    if (!IsObject(data)) {
      return data ~= CustomHotkey.TrayTipAction.prefixRegex
    }
    return IsObject(data) && ObjHasKey(data, "traytip")
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.TrayTipAction.defaultOptions}
   */
  normalizeActionData(data) {
    if (!IsObject(data)) {
      prefixRegex := CustomHotkey.TrayTipAction.prefixRegex
      match := CustomHotkey.Util.regexMatch(data, prefixRegex)
      if (!match) {
        return this.setDefaultOptions({ tooltip: data })
      }

      data := { traytip: RegExReplace(data, prefixRegex, "") }
      if (match.options) {
        optionDefinitionMap := { "R": { name: "replace", type: "boolean" }
                               , "S": { name: "silent", type: "boolean" }
                               , "I": { name: "icon", type: "string" }
                               , "T": { name: "title", type: "string" } }
        options := CustomHotkey.Util.parseOptionsString(match.options, optionDefinitionMap)
        data := this.setDefaultOptions(data, options)
      }
    }

    return this.setDefaultOptions(data)
  }
  /**
   * Execute the Action.
   */
  call() {
    static iconIdMap := { "info": 1, "infomation": 1
                        , "warn": 2, "warning": 2
                        , "error": 3 }

    data := this.data
    message := data.replace
      ? CustomHotkey.Util.templateString(data.traytip)
      : data.traytip

    iconId := iconIdMap.haskey(data.icon) ? iconIdMap[data.icon] : 0
    TrayTip, % data.title, % data.traytip, , % iconId + (data.silent ? 16 : 0)
  }
}