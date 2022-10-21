class ConditionBase {
  static defaultOptions := {}
  /**
   * @param {any} data
   */
  __NEW(data) {
    this.data := this.normalizeConditionData(data)
  }
  /**
   * @param {any} caller
   * @param {any[]} params*
   * @return {any}
   */
  __CALL(caller, params*) {
    if (caller == "" || IsObject(caller)) {
      ; Ignore the caller
      result := this.call(params*)
      return result
    }
  }
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isConditionData(data) {
    return false
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.ConditionBase.defaultOptions}
   */
  normalizeConditionData(data) {
    return this.setDefaultOptions(data)
  }
  /**
   * @static
   * @param {any} data
   * @param {any} [optionName := "defaultOptions"]
   * @return {CustomHotkey.ConditionBase.defaultOptions}
   */
  /**
   * @static
   * @param {any} data
   * @param {any} options
   * @return {CustomHotkey.ConditionBase.defaultOptions}
   */
  setDefaultOptions(data, optionsOrOptionName := "defaultOptions") {
    defaultOptions := IsObject(optionsOrOptionName)
      ? optionsOrOptionName
      : CustomHotkey.Util.getGlobal(this.__CLASS . "." . optionsOrOptionName, {})

    if (CustomHotkey.Util.isEnumerable(data)) {
      data := CustomHotkey.Util.deepDefaultsObject(data, defaultOptions)
    }
    return data
  }
  /**
   * Execute the Condition.
   * @param {any[]} params*
   * @return {any}
   */
  call(params*) {
  }
}