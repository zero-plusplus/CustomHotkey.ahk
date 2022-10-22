class DelayAction extends CustomHotkey.ActionBase {
  static defaultOptions := { delay: 0 }
  static prefixRegex := "i)^(?<prefix>{(?<mode>Delay)(?:\|(?<options>[^\r\n}]+))?})"
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    if (CustomHotkey.Util.isPureNumber(data)) {
      return true
    }
    else if (!IsObject(data)) {
      return return data ~= CustomHotkey.DelayAction.prefixRegex
    }
    return IsObject(data) && ObjHasKey(data, "delay")
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.DelayAction.defaultOptions}
   */
  normalizeActionData(data) {
    if (CustomHotkey.Util.isPureNumber(data)) {
      data := { delay: data }
    }
    else if (!IsObject(data)) {
      prefixRegex := CustomHotkey.DelayAction.prefixRegex
      match := CustomHotkey.Util.regexMatch(data, prefixRegex)
      if (!match) {
        return this.setDefaultOptions({ exit: data })
      }

      data := { delay: RegExReplace(data, prefixRegex, "") }
    }
    data := this.setDefaultOptions(data)
    data.delay := CustomHotkey.Util.timeunit(data.delay, "ms")
    return data
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data

    delay := data.delay
    if (0 < data.delay) {
      Sleep, % data.delay
    }
  }
}