class WindowCondition extends CustomHotkey.ConditionBase {
  static defaultOptions := { matchMode: ""
                           , detectHidden: false
                           , ignoreCase: false }
  __New(data) {
    this.data := CustomHotkey.Util.isPureNumber(data)
      ? CustomHotkey.Util.toNumber(data)
      : this.normalizeConditionData(data)
  }
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isConditionData(data) {
    if (!IsObject(data)) {
      return true
    }

    if (CustomHotkey.Util.isArray(data)) {
      return true
    }

    return (ObjHasKey(data, "active") && !ObjHasKey(data, "exist"))
      || (ObjHasKey(data, "exist") && !ObjHasKey(data, "active"))
      || CustomHotkey.Util.hasAnyKeys(data, [ "title", "text", "id", "hwnd", "class", "pid", "exe", "group" ])
  }
  /**
   * @static
   * @param {any} data
   * @return {{ winActive: any } | { winExist: any }}
   */
  normalizeConditionData(data) {
    data := CustomHotkey.Util.findWindow.normalizeData(data)
    return this.setDefaultOptions(data)
  }
  /**
   * Execute the Condition.
   */
  call() {
    data := this.data

    result := CustomHotkey.Util.findWindow(data)
    return CustomHotkey.Util.toBoolean(result)
  }
}